// MARK: - Service registry protocol

/// Provides service instances registration.
///
/// ### Threading
///
/// `ServiceRegistry` implementations **MUST be thread-safe**.
public protocol ServiceRegistry: AnyObject {
    /// Service identity type
    associatedtype Service: Hashable
    /// Service instance type
    associatedtype Instance: Codable & Hashable

    /// Register an instance for the given service.
    ///
    /// ### Threading
    ///
    /// `callback` may be invoked on arbitrary threads, as determined by implementation.
    ///
    /// - Parameters:
    ///   - service: The service name to add the instance to
    ///   - instance: The instance to add to the service set
    ///   - callback: The closure to receive register result
    func register(_ service: Service, _ instance: Instance, callback: @escaping (Result<Void, Error>) -> Void)

    /// Unregister an instance from the given service.
    ///
    /// ### Threading
    ///
    /// `callback` may be invoked on arbitrary threads, as determined by implementation.
    ///
    /// - Parameters:
    ///   - service: The service name to remove the instance from
    ///   - instance: The instance to remove from the service set
    ///   - callback: The closure to receive register result
    func unregister(_ service: Service, _ instance: Instance, callback: @escaping (Result<Void, Error>) -> Void)
}
