import Foundation

// MARK: - Article Provider Protocol
protocol ArticleProviderProtocol {
    func fetchArticles() async throws -> [Article]
    func fetchArticle(id: Int) async throws -> Article
}
 
