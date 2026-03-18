import SwiftUI
import Kingfisher

struct ArticleDetailView: View {

    let article: Article

    @Environment(\.dismiss) private var dismiss
    @State private var isSaved: Bool = false
    @State private var toast: ToastItem? = nil
    @State private var headerHeight: CGFloat = 0

    private let headerColor = Color(red: 0.11, green: 0.22, blue: 0.29)
    private let bodyBgColor = Color(red: 0.93, green: 0.93, blue: 0.93)
    private let imageHeight: CGFloat = 179
    private let overlapAmount: CGFloat = 179 / 2 // ✅ CHANGE 1: exact 50/50

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
                        .padding(.bottom, overlapAmount + 24) // ✅ CHANGE 2
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        GeometryReader { headerGeo in
                            headerColor
                                .onAppear {
                                    headerHeight = headerGeo.size.height
                                }
                                .onChange(of: headerGeo.size.height) { _, new in
                                    headerHeight = new
                                }
                        }
                    )

                    // ── GREY BODY ──
                    VStack(alignment: .leading, spacing: 0) {

                        Spacer()
                            .frame(height: overlapAmount + 24 + 24) // ✅ CHANGE 3

                        Text(article.bodyText)
                            .font(.system(size: 16))
                            .foregroundStyle(Color(red: 0.25, green: 0.25, blue: 0.25))
                            .lineSpacing(6)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)

                        if let urlString = article.url,
                           let link = URL(string: urlString) {
                            Link(destination: link) {
                                HStack {
                                    Text("Read Full Article")
                                    Image(systemName: "arrow.up.right")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppConstants.Colors.readMoreButton)
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(bodyBgColor)
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 0
                    ))
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
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        Color(red: 0.11, green: 0.53, blue: 0.89),
                                        lineWidth: 2.5
                                    )
                            )
                            .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
                            .padding(.horizontal, 35)
                            .padding(.top, headerHeight - overlapAmount) // ✅ 50/50 split
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .background(bodyBgColor)
        }
        .navigationBarHidden(true)
        .toast(item: $toast)
    }

    // MARK: - TOP BAR
    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.20))
                        .frame(width: 40, height: 40)
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }

            Spacer()

            Text("Article")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            Button { toggleSave() } label: {
                ZStack {
                    Circle()
                        .fill(isSaved
                              ? AppConstants.Colors.readMoreButton
                              : Color.white.opacity(0.20))
                        .frame(width: 40, height: 40)
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                }
            }
        }
    }

    private func toggleSave() {
        withAnimation(.spring(response: 0.3)) {
            isSaved.toggle()
        }
        toast = ToastItem(
            message: isSaved ? "Article saved ✓" : "Article removed",
            style: isSaved ? .success : .info
        )
    }
}
