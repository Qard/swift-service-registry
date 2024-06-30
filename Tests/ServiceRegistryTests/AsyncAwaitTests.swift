#if compiler(>=5.5) && canImport(_Concurrency)
import Dispatch
@testable import ServiceRegistry
import XCTest

final class MockAsyncServiceRegistry: ServiceRegistry {
    var services: [String: [String]] = [:]

    typealias Service = String
    typealias Instance = String

    init() {}

    func register(_ service: String, _ instance: Instance, callback: @escaping (Result<Void, Error>) -> Void) {
        if services[service] == nil {
            services[service] = []
        }
        services[service]?.append(instance)
        callback(.success(()))
    }

    func unregister(_ service: String, _ instance: Instance, callback: @escaping (Result<Void, Error>) -> Void) {
        if let index = services[service]?.firstIndex(of: instance) {
            services[service]?.remove(at: index)
        }
        callback(.success(()))
    }
}

final class AsyncAwaitTests: XCTestCase {
    let services = MockAsyncServiceRegistry()

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testAsyncRegister() async throws {
        try await services.register("service", "instance")

        XCTAssertEqual(services.services["service"], ["instance"])
    }

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testAsyncUnregister() async throws {
        try await services.register("service", "instance")
        try await services.unregister("service", "instance")

        XCTAssertEqual(services.services["service"], [])
    }
}

#endif
