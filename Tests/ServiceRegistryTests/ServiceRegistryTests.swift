import XCTest
@testable import ServiceRegistry

final class MockServiceRegistry: ServiceRegistry {
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

final class ServiceRegistryTests: XCTestCase {
    let services = MockServiceRegistry()

    func testRegister() throws {
        services.register("service", "instance") { result in
            switch result {
            case .success:
                XCTAssertEqual(self.services.services["service"], ["instance"])
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testUnregister() throws {
        services.register("service", "instance") { result in
            if case .failure(let error) = result {
                XCTFail(error.localizedDescription)
                return
            }

            self.services.unregister("service", "instance") { result in
                switch result {
                case .success:
                    XCTAssertEqual(self.services.services["service"], [])
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
}
