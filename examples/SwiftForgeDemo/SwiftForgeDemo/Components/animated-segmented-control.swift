import SwiftUI

/// A sliding-pill segmented control. Bind it to any selection and supply
/// the options plus a label for each.
struct AnimatedSegmentedControl<Option: Hashable>: View {
    @Binding var selection: Option
    let options: [Option]
    let label: (Option) -> String
    var tint: Color = .accentColor

    @Namespace private var pill
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var selectionAnimation: Animation? {
        reduceMotion ? .none : .snappy(duration: 0.3, extraBounce: 0.15)
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(options, id: \.self) { option in
                let isSelected = option == selection
                Button {
                    select(option)
                } label: {
                    Text(label(option))
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(isSelected ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            if isSelected {
                                Capsule(style: .continuous)
                                    .fill(tint)
                                    .matchedGeometryEffect(id: "pill", in: pill)
                            }
                        }
                        .contentShape(.capsule)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
            }
        }
        .padding(4)
        .background(.quaternary, in: .capsule)
        .accessibilityElement(children: .contain)
    }

    private func select(_ option: Option) {
        guard option != selection else { return }
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
        withAnimation(selectionAnimation) {
            selection = option
        }
    }
}

#Preview {
    struct Demo: View {
        enum Tab: String, CaseIterable { case day = "Day", week = "Week", month = "Month" }
        @State private var tab: Tab = .week
        var body: some View {
            VStack(spacing: 24) {
                AnimatedSegmentedControl(
                    selection: $tab,
                    options: Tab.allCases,
                    label: { $0.rawValue }
                )
                AnimatedSegmentedControl(
                    selection: $tab,
                    options: Tab.allCases,
                    label: { $0.rawValue },
                    tint: .pink
                )
                Text("Selected: \(tab.rawValue)")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
    return Demo()
}
