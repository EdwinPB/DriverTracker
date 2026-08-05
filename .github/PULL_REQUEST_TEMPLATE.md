## Description

<!-- What does this PR do? One or two sentences. -->

## Checklist

- [ ] `Scripts/check-architecture.sh` passes
- [ ] `Scripts/check-graph.py` passes (no cycles, all edges inward)
- [ ] Affected packages build: `swift build --package-path Packages/<Name>`
- [ ] App builds with warnings-as-errors (Debug + Release)
- [ ] No `Testing` import in production targets
- [ ] Dependency changes: README whitelist + `check-architecture.sh` updated together
- [ ] New code is strict-concurrency-clean
- [ ] Tests added for behavioral changes
- [ ] No new remote (`url:`) package dependencies

## Related issues

<!-- Closes #123 -->

## Notes

<!-- Anything reviewers should know: design decisions, follow-ups, performance trade-offs. -->
