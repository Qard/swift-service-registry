import Dispatch

#if compiler(>=5.5) && canImport(_Concurrency)

public extension ServiceRegistry {
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func register(_ service: Service, _ instance: Instance) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.register(service, instance) { result in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func unregister(_ service: Service, _ instance: Instance) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.unregister(service, instance) { result in
                switch result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

#endif
