import SwiftUI

// MARK: - Toast Style
enum ToastStyle {
    case info, success, warning, error

    var color: Color {
        switch self {
        case .info:    return Color(UIColor.systemBlue)
        case .success: return Color(UIColor.systemGreen)
        case .warning: return Color.orange
        case .error:   return Color(UIColor.systemRed)
        }
    }

    var icon: String {
        switch self {
        case .info:    return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error:   return "xmark.circle.fill"
        }
    }
}

// MARK: - Toast Item
struct ToastItem: Equatable {
    let id      = UUID()
    let message: String
    let style:   ToastStyle

    static func == (lhs: ToastItem, rhs: ToastItem) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Toast View
struct ToastView: View {
    let item: ToastItem

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: item.style.icon)
                .foregroundStyle(item.style.color)
                .font(.system(size: 16, weight: .semibold))

            Text(item.message)
                .font(AppConstants.Fonts.caption())
                .foregroundStyle(.primary)
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.CornerRadius.button)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
    }
}

// MARK: - Toast Modifier
struct ToastModifier: ViewModifier {
    @Binding var toast: ToastItem?
    @State   private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if let toast {
                ToastView(item: toast)
                    .padding(.bottom, 48)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(999)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: toast)
        .onChange(of: toast) { _, newToast in
            if newToast != nil {
                workItem?.cancel()
                let task = DispatchWorkItem {
                    withAnimation { toast = nil }
                }
                workItem = task
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
            }
        }
    }
}

extension View {
    func toast(item: Binding<ToastItem?>) -> some View {
        modifier(ToastModifier(toast: item))
    }
}

// MARK: - Offline Banner
struct OfflineBannerView: View {
    var body: some View {
        HStack(spacing: AppConstants.Spacing.small) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 14, weight: .semibold))
            Text("You're offline — showing cached content")
                .font(AppConstants.Fonts.caption())
        }
        .foregroundStyle(.white)
        .padding(.horizontal, AppConstants.Spacing.medium)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(AppConstants.Colors.offlineBanner, in: RoundedRectangle(cornerRadius: AppConstants.CornerRadius.small))
        .padding(.horizontal, AppConstants.Spacing.medium)
    }
}
