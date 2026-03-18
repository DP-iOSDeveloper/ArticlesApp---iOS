import Foundation
import Combine
import Reachability
import XCGLogger

// MARK: - Reachability Manager
final class ReachabilityManager: ObservableObject {
    // Initialize directly here
    var objectWillChange = ObservableObjectPublisher()
    
    // MARK: - Singleton
    static let shared = ReachabilityManager()

    // MARK: - Published State
    @Published private(set) var isConnected: Bool = true
    @Published private(set) var connectionType: ConnectionType = .unknown

    enum ConnectionType: String {
        case wifi     = "Wi-Fi"
        case cellular = "Cellular"
        case unknown  = "Unknown"
        case none     = "None"
    }

    private var reachability: Reachability?

    private init() {
        setupReachability()
    }

    private func setupReachability() {
        do {
            reachability = try Reachability()

            reachability?.whenReachable = { [weak self] reachability in
                DispatchQueue.main.async {
                    self?.isConnected    = true
                    self?.connectionType = reachability.connection == .wifi ? .wifi : .cellular
                    NetworkClient.shared.logger.info("🟢 Network reachable via \(reachability.connection)")
                }
            }

            reachability?.whenUnreachable = { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isConnected    = false
                    self?.connectionType = .none
                    NetworkClient.shared.logger.warning("🔴 Network unreachable")
                }
            }

            try reachability?.startNotifier()
        } catch {
            NetworkClient.shared.logger.error("Reachability setup failed: \(error)")
        }
    }

    deinit {
        reachability?.stopNotifier()
    }
}
