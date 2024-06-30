# Swift Service Registry

A Service Registry API for Swift. This is designed to be paired with
[swift-service-discovery](https://github.com/apple/swift-service-discovery).

## Getting started

If you have a server-side Swift application and would like to register it for discover by other services within the same system for making HTTP requests or RPCs, then SwiftServiceRegistry is the right library for the job. Below you will find all you need to know to get started.

### Concepts

- **Service Identity**: Each service must have a unique identity. `Service` denotes the identity type used in a backend implementation.
- **Service Instance**: A service may have zero or more instances, each of which has an associated location (typically host-port). `Instance` denotes the service instance type used in a backend implementation.

### Selecting a service registry backend implementation (applications only)

> Note: If you are building a library, you don't need to concern yourself with this section. It is the end users of your library (the applications) who will decide which service registry backend to use. Libraries should never change the service registry implementation as that is something owned by the application.

SwiftServiceRegistry only provides the service registration API. As an application owner, you need to select a service registry backend to make submission available.

Selecting a backend is done by adding a dependency on the desired backend implementation and instantiating it at the beginning of the program.

For example, suppose you have chosen the hypothetical `RedisserviceRegistry` as the backend:

```swift
// 1) Import the service registry backend package
import RedisserviceRegistry

// 2) Create a concrete serviceRegistry object
let serviceRegistry = RedisserviceRegistry(client, namespace: "services")
```

### Registering and instance of a service

To register an instance of a service (where `instance` is `any Codable`):

```swift
serviceRegistry.lookup(service, instance) { result in
    ...
}
```

#### Async APIs

Async APIs are available for Swift 5.5 and above.

To register an instance of a service:

```swift
try await serviceRegistry.register(service, instance)
```

## Implementing a service registry backend

> Note: Unless you need to implement a custom service registry backend, everything in this section is likely not relevant, so please feel free to skip.

### Adding the dependency

To add a dependency on the API package, you need to declare it in your `Package.swift`:

```swift
.package(url: "https://github.com/qard/swift-service-registry.git", from: "0.1.0"),
```

and to your library target, add "ServiceRegistry" to your dependencies:

```swift
.target(
    name: "MyServiceRegistry",
    dependencies: [
        .product(name: "ServiceRegistry", package: "swift-service-registry"),
    ]
),
```

To become a compatible service registry backend that all SwiftServiceRegistry consumers can use, you need to implement a type that conforms to the `ServiceRegistry` protocol provided by SwiftServiceRegistry. It includes two methods, `register` and `unregister`.

#### `register`

```swift
/// Registers an instance of the given service. The result will be sent to `callback`.
///
/// `defaultLookupTimeout` will be used to compute `deadline` in case one is not specified.
///
/// - Parameters:
///   - service: The service to register to
///   - instance: The instance to register to the service
///   - callback: The closure to receive register result
func register(_ service: Service, _ instance: Instance, callback: @escaping (Result<Void, Error>) -> Void)
```

`register` adds an instance to the given service and sends the result to `callback`.

The backend implementation should impose a deadline on when the operation will complete. `deadline` should be respected if given, otherwise one should be computed using `defaultLookupTimeout`.

#### `unregister`

```swift
/// Unregisters an instance from the given service. The result will be sent to `callback`.
///
/// `defaultLookupTimeout` will be used to compute `deadline` in case one is not specified.
///
/// - Parameters:
///   - service: The service to unregister from
///   - instance: The instance to unregister from the service
///   - callback: The closure to receive unregister result
func unregister(_ service: Service, _ instance: Instance, callback: @escaping (Result<Void, Error>) -> Void)
```

`unregister` removes an instance from the given service and sends the result to `callback`.

The backend implementation should impose a deadline on when the operation will complete. `deadline` should be respected if given, otherwise one should be computed using `defaultLookupTimeout`.
