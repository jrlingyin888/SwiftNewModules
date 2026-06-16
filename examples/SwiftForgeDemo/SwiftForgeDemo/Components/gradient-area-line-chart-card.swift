import SwiftUI
import Charts

struct GradientAreaLineChartPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double

    init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
}

struct GradientAreaLineChartCard: View {
    let title: String
    let unit: String
    let points: [GradientAreaLineChartPoint]
    var tint: Color = .blue

    private var latest: Double { points.last?.value ?? 0 }

    private var delta: Double {
        guard points.count >= 2 else { return 0 }
        let prev = points[points.count - 2].value
        guard prev != 0 else { return 0 }
        return (latest - prev) / prev
    }

    private var isUp: Bool { delta >= 0 }

    private var latestText: String {
        "\(unit)\(latest.formatted(.number.precision(.fractionLength(0))))"
    }

    private var deltaText: String {
        delta.formatted(.percent.precision(.fractionLength(1)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(latestText)
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .contentTransition(.numericText())

                    Label(deltaText,
                          systemImage: isUp ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(isUp ? .green : .red)
                        .labelStyle(.titleAndIcon)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(title)
                .accessibilityValue(
                    isUp ? "\(latestText), up \(deltaText)" : "\(latestText), down \(deltaText)"
                )
            }

            Chart(points) { point in
                AreaMark(
                    x: .value("Label", point.label),
                    y: .value("Value", point.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        colors: [tint.opacity(0.35), tint.opacity(0.02)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                LineMark(
                    x: .value("Label", point.label),
                    y: .value("Value", point.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(tint)
                .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine().foregroundStyle(.quaternary)
                    AxisValueLabel().font(.caption2)
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel().font(.caption2)
                }
            }
            .frame(minHeight: 160, maxHeight: 240)
            .accessibilityLabel("\(title) trend chart")
        }
        .padding(20)
        .background(.background.secondary, in: .rect(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.separator.opacity(0.5), lineWidth: 0.5)
        }
    }
}

#Preview {
    GradientAreaLineChartCard(
        title: "Monthly Revenue",
        unit: "$",
        points: [
            .init(label: "Jan", value: 4200),
            .init(label: "Feb", value: 3800),
            .init(label: "Mar", value: 5100),
            .init(label: "Apr", value: 4700),
            .init(label: "May", value: 6300),
            .init(label: "Jun", value: 7100)
        ],
        tint: .indigo
    )
    .padding()
}
