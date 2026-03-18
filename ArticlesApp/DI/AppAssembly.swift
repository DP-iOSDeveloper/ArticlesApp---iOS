import Foundation
import Swinject

// MARK: - App Assembly
final class AppAssembly: Assembly {
    func assemble(container: Container) {

        // Provider
        container.register(ArticleProviderProtocol.self) { _ in
            ArticleProvider()
        }.inObjectScope(.container)

        // Manager
        container.register(ArticleManager.self) { resolver in
            let provider = resolver.resolve(ArticleProviderProtocol.self)!
            return ArticleManager(
                provider:     provider,
                cache:        .shared,
                reachability: .shared
            )
        }.inObjectScope(.container)
    }
}

// MARK: - DI Container
enum DI {
    static let container: Container = {
        let c = Container()
        AppAssembly().assemble(container: c)
        return c
    }()

    static func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("DI: Could not resolve \(type)")
        }
        return resolved
    }
}
