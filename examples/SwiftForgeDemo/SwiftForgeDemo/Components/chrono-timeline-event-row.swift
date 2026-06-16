import SwiftUI

/// A single entry in a vertical activity timeline: a colored node on a connecting
/// rail, an SF Symbol badge, a timestamp, a title, and an optional detail line.
/// Compose several in a `VStack(spacing: 0)` to build a full timeline; set
/// `isFirst`/`isLast` so the rail draws only where there is a neighbour.
struct ChronoTimelineEventRow: View {
    let icon: String
    let title: String
    let detail: String?
    let timestamp: String
    let accent: Color
    var isFirst: Bool = false
    var isLast: Bool = false
    /// Hollow node renders as a ring (e.g. an upcoming / pending step).
    var isPending: Bool = false

    private let nodeSize: CGFloat = 30
    private let railWidth: CGFloat = 2

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            railColumn
            content
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue("\(timestamp)\(detail.map { ", \($0)" } ?? "")")
    }

    private var railColumn: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(isFirst ? .clear : accent.opacity(0.25))
                .frame(width: railWidth)
                .frame(height: 6)

            ZStack {
                Circle()
                    .fill(isPending ? AnyShapeStyle(.background) : AnyShapeStyle(accent.gradient))
                    .overlay(Circle().strokeBorder(accent, lineWidth: isPending ? 2 : 0))
                    .frame(width: nodeSize, height: nodeSize)
                    .shadow(color: accent.opacity(isPending ? 0 : 0.4), radius: 4, y: 2)
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(isPending ? AnyShapeStyle(accent) : AnyShapeStyle(.white))
            }

            Rectangle()
                .fill(isLast ? .clear : accent.opacity(0.25))
                .frame(width: railWidth)
                .frame(maxHeight: .infinity)
        }
        .frame(width: nodeSize)
        .accessibilityHidden(true)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer(minLength: 8)
                Text(timestamp)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            if let detail {
                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: .rect(cornerRadius: 14))
        .padding(.bottom, isLast ? 0 : 10)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 0) {
            ChronoTimelineEventRow(icon: "cart.fill", title: "Order placed", detail: "Order #A1029 confirmed and sent to the warehouse.", timestamp: "9:24 AM", accent: .blue, isFirst: true)
            ChronoTimelineEventRow(icon: "shippingbox.fill", title: "Packed", detail: "Items picked and packed for shipment.", timestamp: "11:02 AM", accent: .indigo)
            ChronoTimelineEventRow(icon: "airplane", title: "In transit", detail: "Departed sorting facility in Memphis, TN.", timestamp: "2:47 PM", accent: .orange)
            ChronoTimelineEventRow(icon: "house.fill", title: "Out for delivery", detail: nil, timestamp: "Tomorrow", accent: .green, isLast: true, isPending: true)
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
