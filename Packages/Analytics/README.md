# Analytics

Event tracking facade and provider abstraction.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Interface Adapters (cross-cutting)
- **Current API:** `public enum Analytics {}` (namespace placeholder — no features yet)

## Purpose

Analytics is a facade so features can emit events without caring which provider (or providers) handle them. Swapping Mixpanel → Firebase → self-hosted must be a change in this package alone, not a rewrite across every feature.

## Responsibilities

- Event model and event dispatch
- Provider protocol and concrete adapters
- Session/user property handling
- Opt-out / privacy flag enforcement
- Batching and background flushing

## Ownership

App team member accountable for data privacy. Privacy flag and event schema changes require review.

## Allowed dependencies

- Core

## Forbidden dependencies

- Domain, Networking, Storage, Authentication, Location, SyncEngine, DesignSystem, Testing
- SwiftUI, CoreData, CoreLocation

Analytics is intentionally minimal: it must not know the domain, the network, or the UI.

## Belongs here

- `AnalyticsClient` protocol
- `AnalyticsEvent` structure with name + properties
- Provider adapters (e.g., `FirebaseAnalyticsAdapter`)
- Event batching and flush logic

## Does NOT belong here

- *Deciding* what business events mean — features decide; Analytics only records
- Domain entities or business rules → `Domain`
- HTTP transport → `Networking`
- UI instrumentation/view lifecycle → app target
- Storing analytics locally beyond queuing → `Storage`

**Event naming:** events are defined where they're emitted (feature/app layer), not inside Analytics. Analytics ships the pipe, not the content.

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
