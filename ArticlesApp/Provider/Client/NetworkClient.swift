import Foundation
import Alamofire
import XCGLogger

// MARK: - Network Client
final class NetworkClient {

    // MARK: - Singleton
    static let shared = NetworkClient()

    // MARK: - Logger
    let logger: XCGLogger = {
        let log = XCGLogger(identifier: "ArticlesApp.NetworkClient", includeDefaultDestinations: false)
        let console = ConsoleDestination(owner: log, identifier: "console")
        console.showLogIdentifier  = false
        console.showFunctionName   = true
        console.showThreadName     = true
        console.outputLevel        = XCGLogger.Level.debug
        console.showLevel          = true
        console.showFileName       = true
        console.showLineNumber     = true
        log.add(destination: console)
        log.logAppDetails()
        return log
    }()

    // MARK: - Alamofire Session
    private let session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest  = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity       = true
        return Session(configuration: config)
    }()

    private init() {}

    // MARK: - Generic Request
    func request<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil
    ) async throws -> T {
        logger.info("➡️  \(method.rawValue.uppercased()) \(url)")

        return try await withCheckedThrowingContinuation { continuation in
            session
                .request(url, method: method, parameters: parameters)
                .validate()
                .responseDecodable(of: T.self) { [weak self] response in
                    let statusCode = response.response?.statusCode ?? 0
                    switch response.result {
                    case .success(let value):
                        self?.logger.info("✅ \(url) [\(statusCode)]")
                        continuation.resume(returning: value)
                    case .failure(let error):
                        self?.logger.error("❌ \(url) [\(statusCode)] → \(error.localizedDescription)")
                        // Check if it's actually a decoding error (status 200 but wrong model)
                        if case .responseSerializationFailed(let reason) = error {
                            self?.logger.error("🔴 Decoding failed: \(reason)")
                            continuation.resume(throwing: NetworkError.decodingFailed(error))
                        } else if statusCode > 0 && statusCode != 200 {
                            continuation.resume(throwing: NetworkError.serverError(statusCode))
                        } else if let underlying = error.underlyingError as? URLError,
                                  underlying.code == .notConnectedToInternet {
                            continuation.resume(throwing: NetworkError.offline)
                        } else {
                            continuation.resume(throwing: NetworkError.unknown(error))
                        }
                    }
                }
        }
    }
}
