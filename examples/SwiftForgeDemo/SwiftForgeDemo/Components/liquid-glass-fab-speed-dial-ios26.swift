import SwiftUI

/// A child action surfaced by the speed-dial FAB.
struct GlassFABAction: Identifiable {
    let id = UUID()
    let systemImage: String
    let label: String
    var tint: Color = .accentColor
    let action: () -> Void
}

/// An iOS 26 Liquid Glass FAB that expands into a glass speed-dial of mini actions.
/// The FAB and children share a GlassEffectContainer + glassEffectID to morph.
@available(iOS 26, *)
struct LiquidGlassFABSpeedDial: View {
    let actions: [GlassFABAction]
    var tint: Color = .accentColor

    @State private var isOpen = false
    @Namespace private var glassNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GlassEffectContainer(spacing: 18) {
            VStack(alignment: .trailing, spacing: 18) {
                if isOpen {
                    ForEach(actions) { action in
                        Button {
                            action.action()
                            setOpen(false)
                        } label: {
                            HStack(spacing: 10) {
                                Text(action.label)
                                    .font(.subheadline.weight(.semibold))
                                Image(systemName: action.systemImage)
                                    .font(.body.weight(.semibold))
                                    .frame(width: 24)
                            }
                            .padding(.horizontal, 18)
                            .frame(height: 52)
                            .contentShape(.capsule)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.primary)
                        .glassEffect(.regular.tint(action.tint).interactive(), in: .capsule)
                        .glassEffectID(action.id, in: glassNamespace)
                        .accessibilityLabel(action.label)
                    }
                }

                Button {
                    setOpen(!isOpen)
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(isOpen ? 45 : 0))
                        .frame(width: 60, height: 60)
                        .contentShape(.circle)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.tint(tint).interactive(), in: .circle)
                .glassEffectID("fab-core", in: glassNamespace)
                .accessibilityLabel(isOpen ? "Close menu" : "Open menu")
            }
        }
    }

    private func setOpen(_ open: Bool) {
        if reduceMotion {
            isOpen = open
        } else {
            withAnimation(.bouncy(duration: 0.45)) { isOpen = open }
        }
    }
}

/// Fallback FAB speed dial for iOS 17-25 using ultraThinMaterial shapes.
struct GlassFABSpeedDialFallback: View {
    let actions: [GlassFABAction]
    var tint: Color = .accentColor
    @State private var isOpen = false

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            if isOpen {
                ForEach(actions) { action in
                    Button {
                        action.action()
                        withAnimation(.snappy) { isOpen = false }
                    } label: {
                        HStack(spacing: 10) {
                            Text(action.label).font(.subheadline.weight(.semibold))
                            Image(systemName: action.systemImage).frame(width: 24)
                        }
                        .padding(.horizontal, 18)
                        .frame(height: 52)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.primary)
                    .background(.ultraThinMaterial, in: .capsule)
                    .background(action.tint.opacity(0.25), in: .capsule)
                    .accessibilityLabel(action.label)
                }
            }
            Button {
                withAnimation(.snappy) { isOpen.toggle() }
            } label: {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(isOpen ? 45 : 0))
                    .frame(width: 60, height: 60)
            }
            .buttonStyle(.plain)
            .background(tint, in: .circle)
            .accessibilityLabel(isOpen ? "Close menu" : "Open menu")
        }
    }
}

@available(iOS 26, *)
#Preview {
    ZStack(alignment: .bottomTrailing) {
        LinearGradient(colors: [.teal, .blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

        LiquidGlassFABSpeedDial(
            actions: [
                GlassFABAction(systemImage: "camera.fill", label: "Photo", tint: .pink, action: {}),
                GlassFABAction(systemImage: "square.and.pencil", label: "Note", tint: .orange, action: {}),
                GlassFABAction(systemImage: "mic.fill", label: "Voice", tint: .green, action: {})
            ],
            tint: .blue
        )
        .padding(24)
    }
}
