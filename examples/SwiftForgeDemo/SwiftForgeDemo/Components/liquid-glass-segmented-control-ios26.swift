import SwiftUI

/// An iOS 26 Liquid Glass segmented control. The selection pill is a tinted,
/// interactive glass shape that morphs between segments via `glassEffectID`.
@available(iOS 26, *)
struct LiquidGlassSegmentedControl<Segment: Hashable & Identifiable>: View {
    let segments: [Segment]
    let title: (Segment) -> String
    var systemImage: (Segment) -> String? = { _ in nil }
    var tint: Color = .accentColor
    @Binding var selection: Segment

    @Namespace private var glassNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(segments) { segment in
                    let isSelected = segment == selection
                    Button {
                        if reduceMotion {
                            selection = segment
                        } else {
                            withAnimation(.smooth(duration: 0.35)) { selection = segment }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            if let icon = systemImage(segment) {
                                Image(systemName: icon)
                            }
                            Text(title(segment))
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(isSelected ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .contentShape(.capsule)
                    }
                    .buttonStyle(.plain)
                    .background {
                        if isSelected {
                            Capsule()
                                .fill(.clear)
                                .glassEffect(.regular.tint(tint).interactive(), in: .capsule)
                                .glassEffectID("segment-pill", in: glassNamespace)
                        }
                    }
                    .accessibilityLabel(Text(title(segment)))
                    .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
                }
            }
            .padding(6)
            .glassEffect(.regular, in: .capsule)
        }
    }
}

/// Fallback for iOS 17-25: a material-backed segmented control.
struct GlassSegmentedControlFallback<Segment: Hashable & Identifiable>: View {
    let segments: [Segment]
    let title: (Segment) -> String
    var tint: Color = .accentColor
    @Binding var selection: Segment
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 8) {
            ForEach(segments) { segment in
                let isSelected = segment == selection
                Text(title(segment))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background {
                        if isSelected {
                            Capsule().fill(tint).matchedGeometryEffect(id: "pill", in: ns)
                        }
                    }
                    .contentShape(.capsule)
                    .onTapGesture { withAnimation(.smooth) { selection = segment } }
            }
        }
        .padding(6)
        .background(.ultraThinMaterial, in: .capsule)
    }
}

private struct GlassSegPreviewOption: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

@available(iOS 26, *)
#Preview {
    struct Demo: View {
        let options: [GlassSegPreviewOption]
        @State private var selection: GlassSegPreviewOption

        init() {
            let options = [
                GlassSegPreviewOption(name: "Day", icon: "sun.max.fill"),
                GlassSegPreviewOption(name: "Week", icon: "calendar"),
                GlassSegPreviewOption(name: "Month", icon: "calendar.badge.clock")
            ]
            self.options = options
            _selection = State(initialValue: options[0])
        }

        var body: some View {
            LiquidGlassSegmentedControl(
                segments: options,
                title: { $0.name },
                systemImage: { $0.icon },
                tint: .indigo,
                selection: $selection
            )
            .padding()
        }
    }
    return ZStack {
        LinearGradient(colors: [.purple, .blue, .teal], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        Demo()
    }
}
