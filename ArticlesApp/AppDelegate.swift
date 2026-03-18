import UIKit
import AlamofireNetworkActivityIndicator
import FTLinearActivityIndicator
import XCGLogger

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Network activity indicator (spinner in status bar)
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.3
        NetworkActivityIndicatorManager.shared.completionDelay = 0.3

        // Linear activity indicator (iOS 13+ compatible top bar)
        UIApplication.configureLinearNetworkActivityIndicatorIfNeeded()

        // DI container warm-up
        _ = DI.container

        // Reachability warm-up
        _ = ReachabilityManager.shared

        NetworkClient.shared.logger.info("🚀 ArticlesApp launched")

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NetworkClient.shared.logger.debug("App became active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NetworkClient.shared.logger.debug("App entered background")
    }
}
