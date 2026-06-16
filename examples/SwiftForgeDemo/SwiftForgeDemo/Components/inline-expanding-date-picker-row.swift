import SwiftUI

/// A tappable form row that expands to reveal an inline graphical date picker.
struct InlineExpandingDatePickerRow: View {
    let title: String
    var systemImage: String = "calendar"
    @Binding var date: Date
    var includesTime: Bool = false
    var range: ClosedRange<Date>? = nil
    var tint: Color = .accentColor
    var collapsesOnPick: Bool = true

    @State private var isExpanded = false

    private var components: DatePickerComponents {
        includesTime ? [.date, .hourAndMinute] : [.date]
    }

    private var formatted: String {
        date.formatted(
            includesTime
                ? .dateTime.weekday(.abbreviated).month(.abbreviated).day().hour().minute()
                : .dateTime.weekday(.abbreviated).month(.abbreviated).day().year()
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.snappy(duration: 0.3)) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: systemImage)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(tint)
                        .frame(width: 24)
                    Text(title)
                        .foregroundStyle(.primary)
                    Spacer(minLength: 8)
                    Text(formatted)
                        .font(.callout)
                        .foregroundStyle(isExpanded ? tint : .secondary)
                    Image(systemName: "chevron.down")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 4)

            if isExpanded {
                picker
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: date) { _, _ in
            if collapsesOnPick && !includesTime {
                withAnimation(.snappy(duration: 0.3)) { isExpanded = false }
            }
        }
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var picker: some View {
        Group {
            if let range {
                DatePicker(title, selection: $date, in: range, displayedComponents: components)
            } else {
                DatePicker(title, selection: $date, displayedComponents: components)
            }
        }
        .datePickerStyle(.graphical)
        .labelsHidden()
        .tint(tint)
        .padding(.top, 4)
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var due = Date()
        @State private var meeting = Date().addingTimeInterval(3600)
        var body: some View {
            Form {
                Section("Task") {
                    InlineExpandingDatePickerRow(title: "Due Date", systemImage: "flag.fill", date: $due, tint: .orange)
                }
                Section("Event") {
                    InlineExpandingDatePickerRow(
                        title: "Starts",
                        systemImage: "clock.fill",
                        date: $meeting,
                        includesTime: true,
                        range: Date()...Date().addingTimeInterval(60 * 60 * 24 * 365),
                        tint: .indigo
                    )
                }
            }
        }
    }
    return PreviewHost()
}
