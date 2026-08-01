# Domain

Business entities, value objects, and repository/use-case protocols. The innermost Clean Architecture layer.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Entities & Use Cases (innermost). Everything else depends inward on Domain; Domain depends on nothing meaningful.
- **Current API:** `public enum Domain {}` (namespace placeholder — no features yet)

## Purpose

Domain is the single source of truth for the business model. It owns *what* the app does (entities, rules, contracts) and knows nothing about *how* (networking, storage, UI). Keeping it framework-free means business logic is portable, testable, and impossible to couple to infrastructure.

## Responsibilities

- Entities: `Driver`, `Trip`, `Route`, `TripStatus`
- Value objects: `TripID`, `Coordinates`, `TripDuration`
- Repository protocols: `DriverRepository`, `TripRepository`
- Use-case protocols (e.g., `RecordTripUseCase`) if use cases are extracted
- Business invariants and validation rules

## Ownership

App team / product owner. Domain changes mean business decisions changed — requires explicit sign-off, not just a code review.

## Allowed dependencies

- Core

## Forbidden dependencies

- Networking, Storage, Authentication, Location, SyncEngine, Analytics, DesignSystem, Testing
- UIKit, SwiftUI, CoreLocation, CoreData — no platform frameworks in source
- Any third-party package

If a Domain type needs network, persistence, or UI, it is the wrong shape — expose a protocol instead and let the concrete layer implement it.

## Belongs here

- `Driver`, `Trip` structs
- `enum TripStatus { case inProgress, completed }`
- `protocol TripRepository { ... }` — the *contract*, not the implementation
- Domain validation errors

## Does NOT belong here

- Concrete HTTP clients or DTOs → `Networking`
- CoreData/SwiftData models or repository *implementations* → `Storage`
- `CLLocationManager` wrappers or GPS plumbing → `Location`
- Login/session logic → `Authentication`
- Sync orchestration → `SyncEngine`
- SwiftUI views, view models → app target / `DesignSystem`
- Repository implementations — those live in Storage, injected at the composition root

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
