# Build Settings & Configurations

Production-ready compiler and build configuration for DriverTracker.
Applied at two levels: the Xcode project (`App/DriverTracker.xcodeproj/project.pbxproj`)
and every Swift Package manifest (`Packages/*/Package.swift`).

## Configurations

| Configuration | Purpose |
|---|---|
| Debug | Day-to-day development. No optimization, debug dylibs, testability on |
| Release | App Store / distribution. Optimized, dSYMs, stripped symbols |
| Staging | Release-identical build pointed at the staging backend. Installs side-by-side with prod |

Staging specifics:
- `SWIFT_ACTIVE_COMPILATION_CONDITIONS = "STAGING $(inherited)"` — code can branch with `#if STAGING`
  (e.g., point Networking at the staging API base URL).
- `PRODUCT_BUNDLE_IDENTIFIER = eddy.DriverTracker.staging` — both staging and prod apps
  coexist on one device; QA never uninstalls prod to test.
- Staging clones **Release** optimization. A staging build that behaves differently from
  Release hides bugs; it must be Release with a different endpoint, nothing more.

## Swift settings (project level — all configurations)

### `SWIFT_STRICT_CONCURRENCY = complete`
Enables full Swift 6 data-race safety checking in Swift 5 language mode. Every actor-isolation
violation, non-`Sendable` crossing, and unsafe shared mutable state is diagnosed. For a SwiftUI
app this is the single highest-value setting: SwiftUI is aggressively concurrent (view updates,
async image loading, Combine publishers, background location callbacks), and data races are
the hardest class of bug to reproduce. Finding them at compile time instead of in crash
reports is the point. Complete (not `targeted`) means no code is grandfathered in.

Also applied to every package via `.enableExperimentalFeature("StrictConcurrency")` in
`Package.swift` so app and modules enforce identical rules.

### `SWIFT_TREAT_WARNINGS_AS_ERRORS = YES`
Warnings are errors, in every configuration. Rationale: a warning is a compiler statement that
your code is probably wrong (unused results, deprecated APIs, concurrency hazards, unreachable
paths). Allowing warnings to accumulate trains the team to ignore them, and the one that
matters gets lost in the noise. Zero-warning policy keeps the signal clean. If a warning must
temporarily pass, suppress it explicitly at the call site — never globally.

### `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` (target level, kept from template)
Every type defaults to `@MainActor` unless explicitly marked `nonisolated` or given another
isolation. Ideal default for SwiftUI: views, view models, and most app code must run on the
main thread anyway. Background work (Networking, Storage, SyncEngine internals) opts out
deliberately, which makes the expensive concurrent parts visible in code review.

### `SWIFT_APPROACHABLE_CONCURRENCY` — removed
The Xcode template enables this to ease Swift 6 migration by softening some checks.
With strict concurrency `complete`, approachable concurrency would blunt exactly the
diagnostics we want. Removed — the two settings are mutually exclusive in intent.

### `SWIFT_VERSION = 5.0` (kept)
Swift 5 language mode with complete strict-concurrency checking gives ~all the safety of
Swift 6 mode without the migration cliff. Upgrade path: when all code is strict-clean,
flip to `SWIFT_VERSION = 6.0` as a one-line change.

### `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY = YES` (kept)
Opt-in now to a future compiler requirement: members of a module must be visible via an
explicit import. Prevents a whole class of "it builds on my machine" breakage when the
upcoming feature becomes mandatory.

## Optimization & symbols

### `SWIFT_COMPILATION_MODE = wholemodule` (Release + Staging)
Whole Module Optimization: the compiler sees all files in the module at once, enabling
cross-file inlining, dead-code elimination, and generics specialization. Slower compile,
measurably faster and smaller binary. Debug keeps `incremental` (default) for fast
edit-build-run cycles.

### `STRIP_SWIFT_SYMBOLS = YES` (Release + Staging)
Removes Swift symbol metadata from the shipped binary. Smaller binary, slightly harder
reverse engineering. Debug symbols still live in the dSYM, so crash reports symbolicate
normally.

### `DEBUG_INFORMATION_FORMAT = dwarf-with-dsym` (Release + Staging, kept)
Generates a separate `.dSYM` bundle. Required for symbolicated crash reports from
TestFlight/App Store/production.

## Debug-only settings

### `ENABLE_DEBUG_DYLIB = YES` (Debug)
Links against the Swift debug dylib — significantly faster incremental builds on modern
Xcode (the linker skips re-linking the Swift runtime every build). Off in Release/Staging.

### `ENABLE_TESTABILITY = YES` (Debug, kept)
Allows `@testable import` — test targets see internal members. Off in Release/Staging so
shipping binaries don't expose internals.

### `ONLY_ACTIVE_ARCH = YES` (Debug, kept)
Builds only the current device's architecture. Roughly halves Debug build time.
Off in Release so App Store builds include all architectures.

## Kept template settings worth knowing

| Setting | Why it stays |
|---|---|
| `ENABLE_USER_SCRIPT_SANDBOXING = YES` | Build-phase scripts run sandboxed; prevents scripts from silently mutating the system. Standard since Xcode 15 |
| `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES` | Type-safe asset access (`Image(.logo)`); typos become compile errors |
| `LOCALIZATION_PREFERS_STRING_CATALOGS = YES` + `STRING_CATALOG_GENERATE_SYMBOLS = YES` | Modern `.xcstrings` localization with type-safe generated symbols |
| `SWIFT_EMIT_LOC_STRINGS = YES` | Compiler-extracted localizable strings — no manual `NSLocalizedString` bookkeeping |
| `ENABLE_NS_ASSERTIONS = NO` (Release) | Strips `assert()` from shipped builds |
| `VALIDATE_PRODUCT = YES` (Release) | App Store validation at build time, not upload time |
| `MTL_FAST_MATH = YES` | Faster GPU math; irrelevant until Metal shaders exist, harmless until then |

## Escape hatches (documented, not enabled)

- If strict concurrency surfaces errors in third-party-adjacent glue code you cannot fix
  today: set `SWIFT_STRICT_CONCURRENCY = targeted` temporarily **in that target only**,
  file a ticket, never commit the downgrade without a comment.
- If warnings-as-errors blocks an urgent hotfix on a warning you don't control: fix forward
  or suppress at the call site with `@available`/explicit annotations — do not flip the flag.

## Verification

- `plutil -lint project.pbxproj` → OK
- All 10 packages rebuild with `StrictConcurrency` flag confirmed in the compile invocation
  (`swift build -v`)
- No Xcode on this machine — first open in Xcode should be a clean build with zero errors.
  The template code is trivial and strict-concurrency-clean; if any diagnostic appears it
  will be a small fix in `App/DriverTracker/` sources.
