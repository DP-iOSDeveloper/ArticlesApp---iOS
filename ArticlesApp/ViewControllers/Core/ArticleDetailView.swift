import SwiftUI
import Kingfisher


// MARK: - Article Detail View
struct ArticleDetailView: View {

    let article: Article

    @Environment(\.dismiss) private var dismiss
    @State private var isSaved: Bool = false
    @State private var toast: ToastItem? = nil
    @State private var headerHeight: CGFloat = 0

    private let headerColor = Color(red: 0.11, green: 0.22, blue: 0.29)
    private let bodyBgColor = Color(red: 0.93, green: 0.93, blue: 0.93)
    private let imageHeight: CGFloat = 179
    private let overlapAmount: CGFloat = 179 / 2

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── BLUE HEADER ──
                    VStack(alignment: .leading, spacing: 0) {

                        topBar
                            .padding(.top, geo.safeAreaInsets.top + 10)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)

                        Text(article.formattedTitle)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 12)

                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.white.opacity(0.7))
                            Text(article.timeAgo)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, overlapAmount + 24)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        GeometryReader { headerGeo in
                            headerColor
                                .onAppear { headerHeight = headerGeo.size.height }
                                .onChange(of: headerGeo.size.height) { _, new in headerHeight = new }
                        }
                    )

                    // ── GREY BODY ──
                    VStack(alignment: .leading, spacing: 0) {

                        Spacer().frame(height: overlapAmount + 24 + 24)

                        Text(article.bodyText)
                            .font(.system(size: 16))
                            .foregroundStyle(Color(red: 0.25, green: 0.25, blue: 0.25))
                            .lineSpacing(6)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)

                        if let urlString = article.url, let link = URL(string: urlString) {
                            Link(destination: link) {
                                HStack {
                                    Text("Read Full Article")
                                    Spacer()
                                    Image(systemName: "arrow.up.right.circle.fill")
                                        .font(.system(size: 18))
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    // ✅ Liquid Glass layered button
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(AppConstants.Colors.readMoreButton)
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.white.opacity(0.18), Color.clear],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                    }
                                )
                                .shadow(color: AppConstants.Colors.readMoreButton.opacity(0.45),
                                        radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(bodyBgColor)
                    .offset(y: -28)
                    .padding(.bottom, -28)
                }
                .overlay(alignment: .top) {
                    if headerHeight > 0 {
                        KFImage(article.imageURL.flatMap(URL.init))
                            .placeholder {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppConstants.Colors.imagePlaceholderBg)
                                    .frame(height: imageHeight)
                                    .overlay(
                                        Image(systemName: "newspaper.fill")
                                            .foregroundStyle(.white.opacity(0.25))
                                            .font(.largeTitle)
                                    )
                            }
                            .fade(duration: 0.3)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: imageHeight)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                // ✅ Liquid Glass shimmer border
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.6),
                                                Color(red: 0.11, green: 0.53, blue: 0.89).opacity(0.9),
                                                Color.white.opacity(0.2)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2.5
                                    )
                            )
                            // ✅ Liquid Glass glow shadow
                            .shadow(color: Color(red: 0.11, green: 0.53, blue: 0.89).opacity(0.35),
                                    radius: 12, x: 0, y: 6)
                            .padding(.horizontal, 35)
                            .padding(.top, headerHeight - overlapAmount)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(bodyBgColor)
        }
        // ✅ NATIVE Navigation Bar
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(headerColor, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    // ✅ Liquid Glass back button
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 34, height: 34)
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.white.opacity(0.25), Color.clear],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(width: 34, height: 34)
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                            .frame(width: 34, height: 34)
                        Image(systemName: "arrow.left")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button { toggleSave() } label: {
                    // ✅ Liquid Glass heart button
                    ZStack {
                        Circle()
                            .fill(isSaved
                                  ? AnyShapeStyle(AppConstants.Colors.readMoreButton)
                                  : AnyShapeStyle(.ultraThinMaterial))
                            .frame(width: 34, height: 34)
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.white.opacity(0.2), Color.clear],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(width: 34, height: 34)
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                            .frame(width: 34, height: 34)
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .font(.system(size: 15))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .toast(item: $toast)
    }

    // topBar kept for layout reference only (hidden behind nav bar)
    private var topBar: some View {
        // Empty — replaced by native toolbar above
        // Kept to preserve header spacing logic
        Color.clear.frame(height: 0)
    }

    private func toggleSave() {
        withAnimation(.spring(response: 0.3)) { isSaved.toggle() }
        toast = ToastItem(
            message: isSaved ? "Article saved ✓" : "Article removed",
            style: isSaved ? .success : .info
        )
    }
}
