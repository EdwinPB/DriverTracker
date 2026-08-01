# Networking

HTTP transport, endpoint definitions, DTOs, and API client. A Clean Architecture **interface adapter** between the app and the backend.

- **Platform:** iOS 18+, Swift 6, swift-tools 6.0
- **Layer:** Interface Adapters
- **Current API:** `public enum Networking {}` (namespace placeholder — no features yet)

## Purpose

Networking exists so no other module ever touches `URLSession`, serialization, or endpoint URLs directly. Features and infrastructure depend on Domain protocols; Networking provides the network-backed implementations. If the API changes, only this package changes.

## Responsibilities

- HTTP client and request pipeline (retry, timeout, auth header injection)
- `Endpoint` protocol and endpoint definitions
- DTOs and JSON mapping
- Response validation and error mapping to Domain/Core error types
- Network-backed implementations of Domain repository protocols (e.g., `TripRepository` over the API)

## Ownership

Backend-facing app team member. Coordinate contract changes with backend.

## Allowed dependencies

- Core
- Domain

## Forbidden dependencies

- Storage, Authentication, Location, SyncEngine, Analytics, DesignSystem, Testing
- SwiftUI, CoreData, CoreLocation

## Belongs here

- `HTTPClient`, `Endpoint`, `APIError`
- `DriverDTO`, `TripDTO`, `Codable` mappers
- `RemoteTripRepository` conforming to `Domain.TripRepository`
- Auth header injection *mechanism* (reads a token via an injected protocol — see note)

## Does NOT belong here

- Business rules or entity validation → `Domain`
- Persistence or caches → `Storage`
- Token storage/session ownership → `Authentication`
- Deciding *when* to retry or reconcile offline changes → `SyncEngine`
- UI or view models → app target

**Note — token access:** Networking may send auth tokens but must not own them. Declare a token-provider protocol in Domain and inject it; Authentication implements it. Keeps Networking decoupled from Authentication.

---

_Contract enforced by `Scripts/check-architecture.sh`. If you change the dependency rules, update the whitelist there first._
