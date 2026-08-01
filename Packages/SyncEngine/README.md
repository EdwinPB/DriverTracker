# SyncEngine

Offline-first synchronization: change queue, push/pull coordination, and conflict resolution.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Application / Use-Case orchestration
- **Current API:** `public enum SyncEngine {}` (namespace placeholder — no features yet)

## Purpose

Driver tracking must work offline (garages, tunnels, rural roads) and reconcile later. SyncEngine is the only module allowed to orchestrate Storage + Networking together. Centralizing sync prevents every feature from rolling its own dirty retry logic and keeps conflict resolution consistent.

## Responsibilities

- Change queue for offline mutations
- Push (upload local changes) and pull (download remote changes) coordination
- Conflict detection and resolution policy
- Reachability gating and retry with backoff
- Sync state machine (`Idle`, `Syncing`, `Offline`, `Conflicting`)
- Cross-device consistency for trips, routes, driver profile

## Ownership

App team member responsible for data consistency. This is the highest-complexity module — changes need careful design review before coding.

## Allowed dependencies

- Core
- Domain
- Networking
- Storage

## Forbidden dependencies

- Authentication, Location, Analytics, DesignSystem, Testing

**Note:** SyncEngine may need a session token for API calls. Consume a token-provider protocol declared in Domain and injected at the composition root — do not add a dependency on Authentication.

## Belongs here

- `SyncCoordinator`, `SyncQueue`, `SyncStateMachine`
- Conflict resolution strategies
- Retry/backoff and reachability handling
- Background sync scheduling

## Does NOT belong here

- HTTP client or endpoint definitions → `Networking`
- Database schema or local repository implementations → `Storage`
- Login/session ownership → `Authentication`
- GPS sampling → `Location`
- Tracking sync events → `Analytics` (SyncEngine may report state; features decide the events — keep it decoupled via protocol or app layer)
- Sync UI (progress screens, banners) → app target

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
