# Storage

Persistence layer: database stack, caches, migrations, and repository implementations.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Interface Adapters
- **Current API:** `public enum Storage {}` (namespace placeholder — no features yet)

## Purpose

Storage isolates every persistence decision (CoreData vs SwiftData vs SQLite, schema, migrations, cache invalidation) inside one package. The rest of the app talks to Domain repository protocols; Storage provides the durable implementations. Swapping the database backend must not touch a single line outside this package.

## Responsibilities

- Database stack setup (store, context/container)
- Schema model and migrations
- Repository implementations conforming to `Domain` protocols (`LocalTripRepository`, `LocalDriverRepository`)
- Object mapping between persistence models and Domain entities
- Local cache with invalidation policies
- Transaction and error handling

## Ownership

App team member responsible for data integrity. Schema/migration changes are high-risk and versioned.

## Allowed dependencies

- Core
- Domain

## Forbidden dependencies

- Networking, Authentication, Location, SyncEngine, Analytics, DesignSystem, Testing
- UIKit, SwiftUI, CoreLocation, network APIs

Storage must not make network calls. If a repository needs remote data, it belongs to a coordinator (see SyncEngine) that composes Storage + Networking.

## Belongs here

- CoreData/SwiftData model and `NSPersistentContainer` stack
- `LocalTripRepository: TripRepository`
- Migration logic
- Query helpers and caching layer

## Does NOT belong here

- Repository *protocols* → `Domain`
- HTTP calls or remote fetch → `Networking`
- Sync scheduling, push/pull orchestration → `SyncEngine`
- Session/token persistence → `Authentication` (it stores its own secrets in Keychain)
- Business validation rules → `Domain`
- UI → app target

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
