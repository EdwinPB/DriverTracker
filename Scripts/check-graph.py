#!/usr/bin/env python3
"""check-graph.py — build the package dependency graph, prove it acyclic, emit a Mermaid diagram.

Reads every Packages/*/Package.swift, extracts local path dependencies,
topologically sorts the graph (Kahn's algorithm), and prints:
  1. the topo order (proof of no cycles — algorithm fails otherwise)
  2. layer assignment (longest path from Core)
  3. a Mermaid diagram for Docs/architecture.md

Exit 1 on cycle. Run: Scripts/check-graph.py
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PACKAGES = ROOT / "Packages"

DEP_RE = re.compile(r'\.package\(path:\s*"\.\./([A-Za-z]+)"\)')

# Conceptual Clean Architecture layers (design intent, not just dependency depth).
# The dependency rule: every edge must point to a STRICTLY lower layer.
LAYERS = {
    "Core": 0,
    "Domain": 1,
    "Networking": 2,
    "Storage": 2,
    "Location": 2,
    "Analytics": 2,
    "DesignSystem": 2,
    "Testing": 2,
    "Authentication": 3,
    "SyncEngine": 4,
}

LAYER_NAMES = {
    0: "Foundation",
    1: "Entities & contracts",
    2: "Interface adapters",
    3: "Application services",
    4: "Orchestration",
}


def parse_graph():
    graph = {}
    for manifest in sorted(PACKAGES.glob("*/Package.swift")):
        name = manifest.parent.name
        deps = sorted(set(DEP_RE.findall(manifest.read_text())))
        graph[name] = deps
    return graph


def topo_order(graph):
    """Kahn's algorithm over dependency edges. Returns build order; exits on cycle."""
    done = set()
    remaining = set(graph)
    order = []
    while remaining:
        ready = sorted(n for n in remaining if all(d in done for d in graph[n]))
        if not ready:
            stuck = ", ".join(sorted(remaining))
            print(f"CYCLE DETECTED — no acyclic ordering exists for: {stuck}", file=sys.stderr)
            sys.exit(1)
        order.extend(ready)
        done.update(ready)
        remaining.difference_update(ready)
    return order


def verify_dependency_rule(graph):
    """Every edge must point to a strictly lower conceptual layer. Exit 1 on violation."""
    ok = True
    for n in sorted(graph):
        for d in graph[n]:
            if LAYERS.get(n, -1) <= LAYERS.get(d, 99):
                print(f"DEPENDENCY RULE VIOLATION: {n} (L{LAYERS.get(n)}) -> {d} "
                      f"(L{LAYERS.get(d)}) does not point strictly inward", file=sys.stderr)
                ok = False
    if not ok:
        sys.exit(1)


def mermaid(graph, layers):
    lines = ["```mermaid", "graph TD"]
    by_layer = {}
    for n, lv in layers.items():
        by_layer.setdefault(lv, []).append(n)
    for lv in sorted(by_layer):
        label = LAYER_NAMES.get(lv, f"Layer {lv}")
        lines.append(f'    subgraph L{lv}["Layer {lv} · {label}"]')
        for n in sorted(by_layer[lv]):
            lines.append(f"        {n}")
        lines.append("    end")
    lines.append('    subgraph AppLayer["Composition root"]')
    lines.append("        App")
    lines.append("    end")
    for n in sorted(graph):
        for d in graph[n]:
            lines.append(f"    {n} --> {d}")
    for n in sorted(graph):
        lines.append(f"    App -.-> {n}")
    lines.append("```")
    return "\n".join(lines)


def main():
    graph = parse_graph()
    if not graph:
        print("No packages found", file=sys.stderr)
        sys.exit(1)

    order = topo_order(graph)
    verify_dependency_rule(graph)
    layers = LAYERS

    edges = [(n, d) for n in sorted(graph) for d in graph[n]]
    print(f"Packages: {len(graph)}   Edges: {len(edges)}   Cycles: 0 (topo sort succeeded)")
    print(f"Dependency rule: all {len(edges)} edges point strictly inward — OK")
    print(f"Build order: {' -> '.join(order)}")
    print()
    for lv in sorted(set(layers.values())):
        members = ", ".join(sorted(n for n, l in layers.items() if l == lv))
        print(f"Layer {lv} ({LAYER_NAMES.get(lv, '?')}): {members}")
    print()
    print(mermaid(graph, layers))


if __name__ == "__main__":
    main()
