import Foundation
import Cache
import XCGLogger

// MARK: - Cache Manager
final class CacheManager {

    // MARK: - Singleton
    static let shared = CacheManager()

    private var storage: Storage<String, [Article]>?

    private init() {
        let diskConfig = DiskConfig(
            name: "com.articlesapp.cache",
            expiry: .date(Date().addingTimeInterval(60 * 60)), // 1 hour
            maxSize: 10_000_000 // 10 MB
        )
        let memoryConfig = MemoryConfig(
            expiry: .never,
            countLimit: 100,
            totalCostLimit: 0
        )
        storage = try? Storage<String, [Article]>(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: [Article].self)
        )
    }

    // MARK: - Save
    func save(_ articles: [Article], forKey key: String) {
        do {
            try storage?.setObject(articles, forKey: key)
            NetworkClient.shared.logger.debug("💾 Cached \(articles.count) articles for key: \(key)")
        } catch {
            NetworkClient.shared.logger.error("Cache write failed: \(error)")
        }
    }

    // MARK: - Load
    func load(forKey key: String) -> [Article]? {
        do {
            let articles = try storage?.object(forKey: key)
            if let articles {
                NetworkClient.shared.logger.debug("📦 Cache HIT — \(articles.count) articles for key: \(key)")
            } else {
                NetworkClient.shared.logger.debug("📭 Cache MISS for key: \(key)")
            }
            return articles
        } catch {
            NetworkClient.shared.logger.debug("📭 Cache MISS for key: \(key)")
            return nil
        }
    }

    // MARK: - Clear
    func clearAll() {
        try? storage?.removeAll()
        NetworkClient.shared.logger.info("🗑️  Cache cleared")
    }

    // MARK: - Check expiry
    func isExpired(forKey key: String) -> Bool {
        guard let storage else { return true }
        return (try? storage.isExpiredObject(forKey: key)) ?? true
    }
}
