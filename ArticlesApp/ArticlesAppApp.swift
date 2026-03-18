import SwiftUI

@main
struct ArticlesAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ArticleListView()
        }
    }
}
