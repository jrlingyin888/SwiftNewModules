import SwiftUI
import Charts

struct DonutSegment: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}

struct DonutRingChartCenterLabel: View {
    let title: String
    let segments: [DonutSegment]
    var centerUnit: String = ""

    private var total: Double { segments.reduce(0) { $0 + $1.amount } }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.headline)

            Chart(segments) { segment in
                SectorMark(
                    angle: .value("Amount", segment.amount),
                    innerRadius: .ratio(0.62),
                    angularInset: 1.5
                )
                .cornerRadius(4)
                .foregroundStyle(segment.color)
                .accessibilityLabel(segment.name)
                .accessibilityValue(segment.amount.formatted())
            }
            .chartLegend(.hidden)
            .frame(height: 200)
            .overlay {
                VStack(spacing: 2) {
                    Text("\(centerUnit)\(total, format: .number.precision(.fractionLength(0)))")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .contentTransition(.numericText())
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Total \(centerUnit)\(total.formatted())")
            }

            VStack(spacing: 10) {
                ForEach(segments) { segment in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(segment.color)
                            .frame(width: 10, height: 10)
                        Text(segment.name)
                            .font(.subheadline)
                        Spacer(minLength: 8)
                        Text((segment.amount / max(total, 1)).formatted(.percent.precision(.fractionLength(0))))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
            }
        }
        .padding(20)
        .background(.background.secondary, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    DonutRingChartCenterLabel(
        title: "Spending Breakdown",
        segments: [
            .init(name: "Housing", amount: 1800, color: .blue),
            .init(name: "Food", amount: 620, color: .green),
            .init(name: "Transit", amount: 340, color: .orange),
            .init(name: "Fun", amount: 280, color: .pink),
            .init(name: "Other", amount: 160, color: .gray)
        ],
        centerUnit: "$"
    )
    .padding()
}
