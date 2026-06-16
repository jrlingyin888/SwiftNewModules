import SwiftUI

struct StatusIndicatorPill: View {
    let title: String
    var color: Color = .green
    var symbol: String? = nil
    var isLive: Bool = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulse = false

    var body: some View {
        HStack(spacing: 6) {
            if let symbol {
                Image(systemName: symbol)
                    .font(.caption2.weight(.bold))
                    .accessibilityHidden(true)
            } else {
                Circle()
                    .fill(color)
                    .frame(width: 7, height: 7)
                    .overlay {
                        if isLive {
                            Circle()
                                .stroke(color, lineWidth: 2)
                                .scaleEffect(pulse ? 2.4 : 1)
                                .opacity(pulse ? 0 : 0.7)
                        }
                    }
                    .accessibilityHidden(true)
            }
            Text(title)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.15), in: Capsule())
        .overlay(Capsule().strokeBorder(color.opacity(0.3), lineWidth: 0.5))
        .onAppear {
            guard isLive, !reduceMotion else { return }
            withAnimation(.easeOut(duration: 1.4).repeatForever(autoreverses: false)) {
                pulse = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Status: \(title)"))
    }

    static func online() -> StatusIndicatorPill { .init(title: "Online", color: .green, isLive: true) }
    static func away() -> StatusIndicatorPill { .init(title: "Away", color: .orange) }
    static func busy() -> StatusIndicatorPill { .init(title: "Busy", color: .red, symbol: "minus.circle.fill") }
    static func offline() -> StatusIndicatorPill { .init(title: "Offline", color: .secondary) }
    static func success() -> StatusIndicatorPill { .init(title: "Completed", color: .green, symbol: "checkmark") }
    static func pending() -> StatusIndicatorPill { .init(title: "Pending", color: .orange, symbol: "clock.fill") }
    static func failed() -> StatusIndicatorPill { .init(title: "Failed", color: .red, symbol: "xmark") }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        HStack(spacing: 8) {
            StatusIndicatorPill.online()
            StatusIndicatorPill.away()
            StatusIndicatorPill.busy()
            StatusIndicatorPill.offline()
        }
        HStack(spacing: 8) {
            StatusIndicatorPill.success()
            StatusIndicatorPill.pending()
            StatusIndicatorPill.failed()
        }
        StatusIndicatorPill(title: "Live", color: .pink, symbol: "dot.radiowaves.left.and.right", isLive: true)
    }
    .padding()
}
