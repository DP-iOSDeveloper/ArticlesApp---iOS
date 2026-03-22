import SwiftUI


// MARK: - View Mode
enum ViewMode { case list, grid }

// MARK: - Article List View
struct ArticleListView: View {

    @StateObject private var manager     = ArticleManager()
    @StateObject private var router      = Router()
    @ObservedObject private var reach    = ReachabilityManager.shared

    @State private var viewMode: ViewMode  = .list
    @State private var searchText          = ""
    @State private var isSearching         = false
    @State private var toast: ToastItem?   = nil

    @FocusState private var searchFocused: Bool

    private var displayed: [Article] {
        manager.filteredArticles(query: searchText)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 0) {

                // ── Nav Bar ──────────────────────────────────────────
                navBar
                    .background(Color(UIColor.systemBackground))

                Divider().opacity(0.4)

                // ── Body ─────────────────────────────────────────────
                ZStack {
                    Color(UIColor.systemBackground)

                    if !reach.isConnected && manager.articles.isEmpty {
                        offlineView
                    } else if manager.isLoading && manager.articles.isEmpty {
                        loadingView
                    } else {
                        scrollContent
                    }
                }
            }
            // ✅ Native searchable from 2nd code — iOS 26 Liquid Glass search bar
            .searchable(
                text: $searchText,
                isPresented: $isSearching,
                prompt: "Search articles…"
            )
            .navigationBarHidden(true)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .articleDetail(let article):
                    ArticleDetailView(article: article).environmentObject(router)
                }
            }
            .onChange(of: reach.isConnected) { _, connected in
                toast = ToastItem(
                    message: connected ? "Back online ✓" : "You're offline",
                    style:   connected ? .success : .warning
                )
            }
            .task { await manager.loadArticles() }
        }
        .environmentObject(router)
        .toast(item: $toast)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSearching)
        .animation(.easeInOut(duration: 0.2), value: viewMode)
    }

    // MARK: - Nav Bar (from 1st code — unchanged)
    private var navBar: some View {
        HStack(spacing: 12) {
            Text("Articles")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.primary)

            Spacer()

            // Grid / List toggle — Liquid Glass
            Button {
                viewMode = (viewMode == .list) ? .grid : .list
            } label: {
                liquidGlassIcon(
                    systemName: viewMode == .list ? "square.grid.2x2" : "list.bullet"
                )
            }

            // Search toggle — Liquid Glass
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isSearching.toggle()
                    if !isSearching {
                        searchText = ""
                        searchFocused = false
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            searchFocused = true
                        }
                    }
                }
            } label: {
                liquidGlassIcon(
                    systemName: isSearching ? "xmark" : "magnifyingglass"
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Liquid Glass Icon (from 1st code — unchanged)
    private func liquidGlassIcon(systemName: String) -> some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 36, height: 36)
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.3), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 36, height: 36)
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.5), Color.white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
                .frame(width: 36, height: 36)
            Image(systemName: systemName)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppConstants.Colors.readMoreButton)
        }
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
    }

    // MARK: - Scroll Content
    private var scrollContent: some View {
        ScrollView(showsIndicators: false) {
            if viewMode == .list {
                listLayout
            } else {
                gridLayout
            }
        }
        .refreshable { await manager.refresh() }
    }

    // MARK: - List Layout
    private var listLayout: some View {
        LazyVStack(spacing: 16) {
            if displayed.isEmpty && !searchText.isEmpty {
                emptySearch
            }
            ForEach(displayed) { article in
                ArticleListCardView(article: article) {
                    router.navigate(to: .articleDetail(article))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 32)
    }

    // MARK: - Grid Layout
    private var gridLayout: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            if displayed.isEmpty && !searchText.isEmpty {
                emptySearch
            }
            ForEach(displayed) { article in
                ArticleGridCardView(article: article) {
                    router.navigate(to: .articleDetail(article))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 32)
    }

    // MARK: - Offline
    private var offlineView: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "wifi.slash")
                .font(.system(size: 64, weight: .thin))
                .foregroundStyle(Color(UIColor.label))
            Text("You're offline")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color(UIColor.label))
            Text("Please connect to the internet and try again.")
                .font(.system(size: 15))
                .foregroundStyle(Color(UIColor.secondaryLabel))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button {
                Task { await manager.refresh() }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Retry")
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color(UIColor.label))
                .padding(.horizontal, 32)
                .padding(.vertical, 13)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(Capsule().stroke(Color(UIColor.label).opacity(0.25), lineWidth: 1))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6))
    }

    // MARK: - Loading
    private var loadingView: some View {
        VStack(spacing: 14) {
            Spacer()
            ProgressView().scaleEffect(1.3)
            Text("Loading…").font(.system(size: 15)).foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Empty Search
    private var emptySearch: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(.tertiary)
            Text("No results for \"\(searchText)\"")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

