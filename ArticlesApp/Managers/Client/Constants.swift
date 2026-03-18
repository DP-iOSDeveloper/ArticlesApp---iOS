import SwiftUI

// MARK: - App Constants
enum AppConstants {

    // MARK: - API
    enum API {
        static let articlesURL = "https://mocki.io/v1/50422b19-547f-41c0-b623-e82d886ad264"
    }

    // MARK: - Cache Keys
    enum Cache {
        static let articlesKey = "articles_v1"
    }

    // MARK: - Colors (matched to Figma)
    enum Colors {
        // Card dark teal background
        static let cardBackground    = Color(red: 0.11, green: 0.22, blue: 0.29)  // #1C3A4A
        // Read More button blue
        static let readMoreButton    = Color(red: 0.145, green: 0.388, blue: 0.922) // #2563EB
        // Page background
        static let pageBackground    = Color(UIColor.systemBackground)
        static let offlineBackground = Color(UIColor.systemGray6)
        // Text
        static let cardTitle         = Color.white
        static let cardDate          = Color(white: 0.75)
        static let primaryText       = Color(UIColor.label)
        static let secondaryText     = Color(UIColor.secondaryLabel)
        // Detail header
        static let detailHeader      = Color(red: 0.11, green: 0.22, blue: 0.29)
        static let detailHeaderText  = Color.white
        static let offlineBanner     = Color.orange
        static let accent            = Color.accentColor
        static let imagePlaceholderBg = Color(red: 0.15, green: 0.15, blue: 0.18)
    }

    // MARK: - Typography (matched to Figma)
    enum Fonts {
        static func navTitle()     -> Font { .system(size: 28, weight: .bold,    design: .default) }
        static func cardTitle()    -> Font { .system(size: 16, weight: .bold,    design: .default) }
        static func cardDate()     -> Font { .system(size: 13, weight: .regular, design: .default) }
        static func readMore()     -> Font { .system(size: 14, weight: .semibold,design: .default) }
        static func detailTitle()  -> Font { .system(size: 22, weight: .bold,    design: .default) }
        static func detailTime()   -> Font { .system(size: 13, weight: .regular, design: .default) }
        static func body()         -> Font { .system(size: 16, weight: .regular, design: .default) }
        static func caption()      -> Font { .system(size: 12, weight: .medium,  design: .default) }
        static func offlineTitle() -> Font { .system(size: 18, weight: .bold,    design: .default) }
        static func offlineSub()   -> Font { .system(size: 15, weight: .regular, design: .default) }
    }

    // MARK: - Layout
    enum Spacing {
        static let xs:      CGFloat = 4
        static let small:   CGFloat = 8
        static let medium:  CGFloat = 16
        static let large:   CGFloat = 24
        static let xLarge:  CGFloat = 32
        static let xxLarge: CGFloat = 48
    }

    enum CornerRadius {
        static let card:    CGFloat = 16
        static let image:   CGFloat = 12
        static let button:  CGFloat = 12
        static let chip:    CGFloat = 100
        static let small:   CGFloat = 8
    }

    enum Dimensions {
        static let listImageHeight:  CGFloat = 200
        static let gridImageHeight:  CGFloat = 130
        static let detailImageHeight:CGFloat = 220
        static let avatarSize:       CGFloat = 40
    }
}
