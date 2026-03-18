import Foundation
import SwiftUI
import Combine
import XCGLogger

// MARK: - Article Manager
@MainActor
final class ArticleManager: ObservableObject {

    // MARK: - Published State
    @Published private(set) var articles:     [Article] = []
    @Published private(set) var isLoading:    Bool      = false
    @Published private(set) var errorMessage: String?   = nil
    @Published private(set) var isFromCache:  Bool      = false

    // MARK: - Dependencies (injected via Swinject)
    private let provider:     ArticleProviderProtocol
    private let cache:        CacheManager
    private let reachability: ReachabilityManager
    private let logger        = NetworkClient.shared.logger

    init(
        provider:     ArticleProviderProtocol = ArticleProvider(),
        cache:        CacheManager            = .shared,
        reachability: ReachabilityManager     = .shared
    ) {
        self.provider     = provider
        self.cache        = cache
        self.reachability = reachability
    }

    // MARK: - Load Articles
    func loadArticles(forceRefresh: Bool = false) async {
        errorMessage = nil

        // Serve from cache first (unless force refresh)
        if !forceRefresh, let cached = cache.load(forKey: AppConstants.Cache.articlesKey) {
            articles    = cached
            isFromCache = true
            logger.info("Served \(cached.count) articles from cache")
            return
        }

        // Check connectivity
        guard reachability.isConnected else {
            // Fall back to cache even if expired
            if let stale = cache.load(forKey: AppConstants.Cache.articlesKey) {
                articles    = stale
                isFromCache = true
                errorMessage = "Showing cached content — you're offline."
            } else {
                errorMessage = NetworkError.offline.errorDescription
            }
            return
        }

        // Fetch from network
        isLoading   = true
        isFromCache = false

        do {
            let fetched = try await provider.fetchArticles()
            articles    = fetched
            cache.save(fetched, forKey: AppConstants.Cache.articlesKey)
            logger.info("Fetched and cached \(fetched.count) articles")
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
            logger.error("ArticleManager fetch error: \(error.localizedDescription)")

            // Fallback to cache on network error
            if let stale = cache.load(forKey: AppConstants.Cache.articlesKey) {
                articles    = stale
                isFromCache = true
            }
        } catch {
            errorMessage = error.localizedDescription
            logger.error("ArticleManager unknown error: \(error)")
        }

        isLoading = false
    }

    // MARK: - Refresh
    func refresh() async {
        await loadArticles(forceRefresh: true)
    }

    // MARK: - Search
    func filteredArticles(query: String) -> [Article] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return articles }
        let q = query.lowercased()
        return articles.filter {
            $0.title.lowercased().contains(q) ||
            $0.bodyText.lowercased().contains(q)  ||
            $0.category.lowercased().contains(q)
        }
    }

    // MARK: - Clear Cache
    func clearCache() {
        cache.clearAll()
        articles    = []
        isFromCache = false
    }
}
