# Core

Pure Swift foundation utilities shared across every module.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Foundation — the bottom of the dependency graph. Nothing depends on it being concrete; everything may.
- **Current API:** `public enum Core {}` (namespace placeholder — no features yet)

## Purpose

Core exists so cross-cutting plumbing (logging, error types, formatting, config) is written once and shared, instead of being re-implemented or — worse — duplicated across feature modules with slightly different behavior.

## Responsibilities

- Logging facade
- Common error types and `Result` helpers
- Formatting (dates, distances, currency, duration)
- App-wide constants and configuration values
- Generic extensions and utilities (no domain meaning)
- Dependency-injection primitives if/when introduced

## Ownership

App team. Every package depends on Core transitively, so changes have the widest blast radius in the repo. Public API changes here require the broadest review.

## Allowed dependencies

- None.

## Forbidden dependencies

- Any DriverTracker package
- UIKit, SwiftUI, CoreLocation, CoreData, or any platform framework in source code
- Any third-party package

Core stays framework-free so it compiles anywhere and is trivially testable. Foundation and standard library only.

## Belongs here

- `Logger`, log formatters
- `AppError` / `DriverTrackerError` enum
- `DateFormatter` factories, distance/duration formatters
- App config values (API base URL lives here only if no secret)
- `Collection`/`String` extensions with no business meaning

## Does NOT belong here

- Domain entities (`Driver`, `Trip`) → `Domain`
- HTTP calls → `Networking`
- Persistence → `Storage`
- Business rules (e.g., "trip cannot end before it starts") → `Domain`
- UI components or SwiftUI views → `DesignSystem`
- App screens → app target

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
