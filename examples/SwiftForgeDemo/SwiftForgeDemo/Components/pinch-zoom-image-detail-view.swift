import SwiftUI

/// A full-screen, pinch-to-zoom photo detail viewer with bounded pan and double-tap zoom.
struct PinchZoomImageDetailView: View {
    let image: Image
    var minScale: CGFloat = 1
    var maxScale: CGFloat = 4

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            image
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
                .frame(width: geo.size.width, height: geo.size.height)
                .contentShape(Rectangle())
                .gesture(magnify(in: geo.size))
                .simultaneousGesture(drag(in: geo.size))
                .onTapGesture(count: 2) { toggleZoom() }
                .accessibilityElement()
                .accessibilityLabel("Zoomable image")
                .accessibilityValue("\(Int(scale * 100)) percent")
                .accessibilityAddTraits(.isImage)
        }
        .background(Color.black)
        .overlay(alignment: .topTrailing) { resetButton }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: scale)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: offset)
        .ignoresSafeArea()
    }

    private var resetButton: some View {
        Button { resetZoom() } label: {
            Label("Reset", systemImage: "arrow.counterclockwise")
                .font(.callout.weight(.semibold))
                .labelStyle(.iconOnly)
                .padding(12)
                .background(.ultraThinMaterial, in: .circle)
        }
        .tint(.white)
        .padding()
        .opacity(scale > 1.01 ? 1 : 0)
        .allowsHitTesting(scale > 1.01)
    }

    private func magnify(in size: CGSize) -> some Gesture {
        MagnifyGesture()
            .onChanged { value in
                scale = min(max(lastScale * value.magnification, minScale * 0.6), maxScale)
            }
            .onEnded { _ in
                scale = min(max(scale, minScale), maxScale)
                lastScale = scale
                clampOffset(in: size)
            }
    }

    private func drag(in size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard scale > 1 else { return }
                let proposed = CGSize(width: lastOffset.width + value.translation.width,
                                      height: lastOffset.height + value.translation.height)
                offset = bounded(proposed, in: size)
            }
            .onEnded { _ in
                clampOffset(in: size)
                lastOffset = offset
            }
    }

    private func bounded(_ proposed: CGSize, in size: CGSize) -> CGSize {
        let maxX = max((size.width * scale - size.width) / 2, 0)
        let maxY = max((size.height * scale - size.height) / 2, 0)
        return CGSize(width: min(max(proposed.width, -maxX), maxX),
                      height: min(max(proposed.height, -maxY), maxY))
    }

    private func clampOffset(in size: CGSize) {
        offset = bounded(offset, in: size)
        lastOffset = offset
    }

    private func toggleZoom() {
        if scale > 1 {
            resetZoom()
        } else {
            scale = 2
            lastScale = 2
        }
    }

    private func resetZoom() {
        scale = 1
        lastScale = 1
        offset = .zero
        lastOffset = .zero
    }
}

#Preview {
    PinchZoomImageDetailView(image: Image(systemName: "photo.artframe"))
}
