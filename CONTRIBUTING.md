# Contributing to DriverTracker

## Before you start

- Read [`Docs/architecture.md`](Docs/architecture.md) — the dependency graph and the
  Clean Architecture rules are enforced, not aspirational.
- Read the `README.md` of any package you touch. The contract (allowed/forbidden
  dependencies) lives there.

## Ground rules

1. **Dependencies point inward only.** A package may only depend on what its README lists
   as allowed. Adding a dependency requires updating **both** the README and the whitelist
   in `Scripts/check-architecture.sh` in the same PR.
2. **No cycles.** `Scripts/check-graph.py` fails on any cycle or outward-pointing edge.
   It must stay green.
3. **Abstractions live in Domain.** Repository/session protocols are declared in Domain,
   implemented in adapters (Storage, Networking, Authentication), injected in the App.
4. **App target is composition only.** No business logic in the app target. If logic belongs
   somewhere, it belongs in a package.
5. **Testing package is test-only.** No production target may import `Testing`.
6. **Warnings are errors.** Zero-warning builds. Suppress at the call site, never globally.
7. **No comments unless they explain why.** Code should read itself; comments justify decisions.

## Workflow

- Branch from `main` for each change: `feat/`, `fix/`, `refactor/`, `docs/`.
- PRs are merged after CI passes (architecture checks, package builds, app builds).
- Keep PRs small and single-purpose — they get faster reviews and cleaner reverts.

## Running checks locally

```sh
Scripts/check-architecture.sh   # dependency whitelist
Scripts/check-graph.py          # cycles + dependency rule
swift build --package-path Packages/<Name>
xcodebuild -project App/DriverTracker.xcodeproj -target DriverTracker \
  -configuration Debug -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

## Package conventions

- One namespace placeholder (`public enum <Package> {}`) is the current scaffold; it is not
  a design — new public API is designed in a PR before implementation.
- Every package keeps its `Package.swift`, `README.md`, and `Sources/<Name>/` layout.
- Strict concurrency is enabled in every manifest — new code must be strict-concurrency-clean.

## Tests

- Unit tests live in each package's test target when introduced.
- Shared test doubles/fixtures go in the `Testing` package.
- Every behavioral change should ship with a test.

## Reporting bugs

Open an issue with the bug report template — device, iOS version, permission state, and
repro steps are required.
