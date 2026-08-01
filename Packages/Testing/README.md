# Testing

Shared test doubles, factories, fixtures, and assertions for unit tests.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Test support (never linked into production)
- **Current API:** `public enum Testing {}` (namespace placeholder — no features yet)

## Purpose

Testing exists so every module's test target mocks, builds fixtures, and asserts the same way. Without it, each package re-implements in-memory repositories and factory helpers, and behavior drifts between test suites.

## Responsibilities

- In-memory repository implementations (fakes conforming to Domain protocols)
- Fixture/factory builders for entities and DTOs
- Test doubles: spies, stubs, mocks
- Shared assertion helpers and matchers
- Deterministic date/clock and scheduler fakes

## Allowed dependencies

- Core
- Domain

## Forbidden dependencies

- Networking, Storage, Authentication, Location, SyncEngine, Analytics, DesignSystem

## Belongs here

- `InMemoryTripRepository`, `InMemoryDriverRepository`
- `DriverFactory.make()`, `TripFixture.anyTrip()`
- `ClockStub`, `DateProviderFake`
- Assertion helpers for common domain checks

## Does NOT belong here

- Production code — **no non-test target may ever depend on Testing**
- Mocking a specific library's internals
- Real network/database behavior (that belongs in integration tests, not here)
- UI snapshot helpers → app target test bundle

**Hard rule:** Testing is imported *only* by test targets. If `swift package dump-package` shows any production package depending on Testing, the architecture check fails.

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
