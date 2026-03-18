import SwiftUI
import Combine

// MARK: - App Routes
enum AppRoute: Hashable {
    case articleDetail(Article)
}

// MARK: - Router
final class Router: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
