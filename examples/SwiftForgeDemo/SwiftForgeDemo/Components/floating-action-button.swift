import SwiftUI

/// A circular floating action button with shadow, press feedback, and an
/// optional inline text label that expands the FAB into a pill.
struct FloatingActionButton: View {
    let systemImage: String
    var title: String? = nil
    var tint: Color = .accentColor
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.title3.weight(.semibold))
                if let title {
                    Text(title)
                        .font(.headline)
                        .fixedSize()
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, title == nil ? 18 : 22)
            .frame(minWidth: 56, minHeight: 56)
            .background(tint, in: .capsule)
            .shadow(color: tint.opacity(0.45), radius: 10, x: 0, y: 6)
            .contentShape(.capsule)
        }
        .buttonStyle(FloatingActionButtonStyle())
        .accessibilityLabel(Text(title ?? "Action"))
        .accessibilityAddTraits(.isButton)
    }
}

/// A button style that applies a springy press-scale effect by reading the
/// configuration's `isPressed` state. This is more robust than a manual
/// `DragGesture` + `@State` flag, which can leave the button stuck in the
/// pressed state if the gesture is interrupted or cancelled.
private struct FloatingActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6),
                       value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<20) { i in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.quaternary)
                        .frame(height: 60)
                        .overlay(Text("Row \(i)").foregroundStyle(.secondary))
                }
            }
            .padding()
        }
        .navigationTitle("Inbox")
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                FloatingActionButton(systemImage: "square.and.pencil",
                                     title: "Compose") {}
                FloatingActionButton(systemImage: "plus", tint: .pink) {}
            }
            .padding(24)
        }
    }
}
