import Foundation

// MARK: - API Response Wrapper
struct ArticlesResponse: Codable {
    let articles: [Article]
}

// MARK: - Article Source
struct ArticleSource: Codable, Hashable {
    let id: String?
    let name: String?
}

// MARK: - Article Model (matches actual API)
struct Article: Codable, Identifiable, Hashable {

    // MARK: - API Fields
    let source:      ArticleSource?
    let author:      String?
    let title:       String
    let description: String?
    let url:         String?
    let urlToImage:  String?
    let publishedAt: String?
    let content:     String?

    // MARK: - Identifiable (computed from url since no id in API)
    var id: String { url ?? title }

    // MARK: - Computed Helpers
    var imageURL: String? { urlToImage }

    var sourceName: String { source?.name ?? "Unknown" }

    var authorName: String { author ?? "Unknown Author" }

    var bodyText: String { content ?? description ?? "No content available." }

    var formattedTitle: String {
        title.prefix(1).uppercased() + title.dropFirst()
    }

    var category: String {
        let categories = ["Technology", "Science", "Health", "Business", "Arts", "Travel", "World"]
        let hash = abs(title.hashValue)
        return categories[hash % categories.count]
    }

    var readTime: Int {
        max(1, bodyText.split(separator: " ").count / 200)
    }

    var timeAgo: String {
        guard let publishedAt else { return "recently" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        guard let date = iso.date(from: publishedAt) else { return "recently" }
        let hours = Int(-date.timeIntervalSinceNow / 3600)
        if hours < 1  { return "just now" }
        if hours < 24 { return "\(hours)h ago" }
        let days = hours / 24
        return "\(days)d ago"
    }

    var formattedDate: String {
        guard let publishedAt else { return "" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let display = DateFormatter()
        display.dateStyle = .medium
        display.timeStyle = .none
        if let date = iso.date(from: publishedAt) {
            return display.string(from: date)
        }
        // fallback without fractional seconds
        iso.formatOptions = [.withInternetDateTime]
        if let date = iso.date(from: publishedAt) {
            return display.string(from: date)
        }
        return publishedAt
    }
}
