import SwiftUI
import Charts

struct GroupedBarDatum: Identifiable {
    let id = UUID()
    let category: String
    let series: String
    let value: Double
}

struct GroupedBarChartCard: View {
    let title: String
    let subtitle: String
    let data: [GroupedBarDatum]
    var seriesColors: KeyValuePairs<String, Color> = [
        "This Year": .accentColor, "Last Year": .secondary
    ]
    /// Axis value format. Defaults to compact numbers; pass a currency
    /// format (e.g. `.currency(code: "USD").notation(.compactName)`) for a
    /// currency-aware axis.
    var axisValueFormat: FloatingPointFormatStyle<Double> = .number.notation(.compactName)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Chart(data) { datum in
                BarMark(
                    x: .value("Category", datum.category),
                    y: .value("Value", datum.value)
                )
                .foregroundStyle(by: .value("Series", datum.series))
                .position(by: .value("Series", datum.series))
                .cornerRadius(5)
            }
            .chartForegroundStyleScale(seriesColors)
            .chartLegend(position: .top, alignment: .leading, spacing: 8)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let number = value.as(Double.self) {
                            Text(number, format: axisValueFormat)
                        }
                    }
                }
            }
            .frame(minHeight: 200, maxHeight: 320)
        }
        .padding(16)
        .background(.background.secondary, in: .rect(cornerRadius: 20))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(title). \(subtitle)")
    }
}

#Preview {
    let sample: [GroupedBarDatum] = [
        .init(category: "Q1", series: "This Year", value: 4200),
        .init(category: "Q1", series: "Last Year", value: 3100),
        .init(category: "Q2", series: "This Year", value: 5600),
        .init(category: "Q2", series: "Last Year", value: 4800),
        .init(category: "Q3", series: "This Year", value: 5100),
        .init(category: "Q3", series: "Last Year", value: 5300),
        .init(category: "Q4", series: "This Year", value: 7200),
        .init(category: "Q4", series: "Last Year", value: 6100)
    ]
    return GroupedBarChartCard(
        title: "Revenue",
        subtitle: "Quarterly comparison",
        data: sample
    )
    .padding()
}
