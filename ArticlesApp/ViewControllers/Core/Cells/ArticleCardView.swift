import SwiftUI
import Kingfisher


// MARK: - List Card
struct ArticleListCardView: View {
    let article: Article
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {

                // ── Thumbnail (with top/left/right padding like Figma) ──
                GeometryReader { geo in
                    if let urlStr = article.imageURL, let url = URL(string: urlStr) {
                        KFImage(url)
                            .fade(duration: 0.2)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: 200)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        AppConstants.Colors.imagePlaceholderBg
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                Image(systemName: "newspaper.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color.white.opacity(0.25))
                            )
                    }
                }
                .frame(height: 200)
                .padding(.top, 16)
                .padding(.horizontal, 16)

                // ── Title ─────────────────────────────
                Text(article.formattedTitle)
                    .font(AppConstants.Fonts.cardTitle())
                    .foregroundStyle(.white)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    .padding(.bottom, 10)

                // ── Footer ────────────────────────────
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.white.opacity(0.6))
                    Text(article.formattedDate.isEmpty ? "—" : article.formattedDate)
                        .font(AppConstants.Fonts.cardDate())
                        .foregroundStyle(Color.white.opacity(0.6))
                        .lineLimit(1)

                    Spacer()

                    HStack(spacing: 6) {
                        Text("Read More")
                            .font(AppConstants.Fonts.readMore())
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 16))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(
                        // ✅ Liquid Glass Read More button
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppConstants.Colors.readMoreButton)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(
                                    colors: [Color.white.opacity(0.15), Color.clear],
                                    startPoint: .top, endPoint: .bottom
                                ))
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                        }
                    )
                    .shadow(color: AppConstants.Colors.readMoreButton.opacity(0.4),
                            radius: 6, x: 0, y: 3)
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
            }
            .background(
                // ✅ Liquid Glass card surface
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppConstants.Colors.cardBackground)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [Color.white.opacity(0.08), Color.clear],
                            startPoint: .top, endPoint: .center
                        ))
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Grid Card
struct ArticleGridCardView: View {
    let article: Article
    let onTap: () -> Void

    private let cardHeight:  CGFloat = 220
    private let imageHeight: CGFloat = 130

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {

                // ── Thumbnail (with top/left/right padding like Figma) ──
                GeometryReader { geo in
                    if let urlStr = article.imageURL, let url = URL(string: urlStr) {
                        KFImage(url)
                            .fade(duration: 0.2)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: imageHeight)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        AppConstants.Colors.imagePlaceholderBg
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                Image(systemName: "newspaper.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(Color.white.opacity(0.25))
                            )
                    }
                }
                .frame(height: imageHeight)
                .padding(.top, 8)
                .padding(.horizontal, 8)

                // ── Title ─────────────────────────────
                Text(article.formattedTitle)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .topLeading)
                    .padding(10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: cardHeight)
            .background(
                // ✅ Liquid Glass card surface
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppConstants.Colors.cardBackground)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [Color.white.opacity(0.08), Color.clear],
                            startPoint: .top, endPoint: .center
                        ))
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.18), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
