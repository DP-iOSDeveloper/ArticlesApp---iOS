import Foundation

// MARK: - Article Provider
final class ArticleProvider: ArticleProviderProtocol {

    private let client = NetworkClient.shared
    private let apiURL = "https://mocki.io/v1/50422b19-547f-41c0-b623-e82d886ad264"

    // MARK: - Fetch all articles
    func fetchArticles() async throws -> [Article] {
        let response: ArticlesResponse = try await client.request(apiURL)
        return response.articles
    }

    // MARK: - Fetch single article by ID (url)
    func fetchArticle(id: Int) async throws -> Article {
        // Not used directly — detail is passed via navigation
        throw NetworkError.noData
    }
}
