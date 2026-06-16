import SwiftUI

/// A KPI/metric card with a value, label, optional icon, and trend delta chip.
struct StatMetricCard: View {
    let title: String
    let value: String
    let icon: String?
    /// Percentage change. Positive renders green/up, negative red/down, nil hides the chip.
    let change: Double?
    let accent: Color

    private let cornerRadius: CGFloat = 20

    init(
        title: String,
        value: String,
        icon: String? = nil,
        change: Double? = nil,
        accent: Color = .accentColor
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.change = change
        self.accent = accent
    }

    private var isUp: Bool { (change ?? 0) >= 0 }
    private var trendColor: Color { isUp ? .green : .red }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(accent)
                        .frame(width: 34, height: 34)
                        .background(accent.opacity(0.15), in: Circle())
                        .accessibilityHidden(true)
                }
                Spacer(minLength: 0)
                if let change {
                    deltaChip(change)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(.separator.opacity(0.5), lineWidth: 0.5)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(accessibilitySummary)
    }

    private func deltaChip(_ change: Double) -> some View {
        HStack(spacing: 2) {
            Image(systemName: isUp ? "arrow.up.right" : "arrow.down.right")
                .font(.caption2.weight(.bold))
            Text(abs(change), format: .percent.precision(.fractionLength(0...1)))
                .font(.caption.weight(.semibold))
                .contentTransition(.numericText())
        }
        .foregroundStyle(trendColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(trendColor.opacity(0.15), in: Capsule())
    }

    private var accessibilitySummary: String {
        guard let change else { return value }
        let dir = isUp ? "up" : "down"
        let pct = abs(change).formatted(.percent.precision(.fractionLength(0...1)))
        return "\(value), \(dir) \(pct)"
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatMetricCard(title: "Revenue", value: "$48.2K", icon: "dollarsign.circle.fill", change: 0.124, accent: .green)
            StatMetricCard(title: "Active Users", value: "12,840", icon: "person.2.fill", change: 0.031, accent: .blue)
            StatMetricCard(title: "Churn", value: "2.4%", icon: "arrow.uturn.left", change: -0.087, accent: .orange)
            StatMetricCard(title: "Sessions", value: "94K", icon: "chart.bar.fill", accent: .purple)
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
