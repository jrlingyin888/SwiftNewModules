import SwiftUI

/// A snapping, paged image carousel with animated page dots and active-page scaling.
struct SnappingImageCarousel: View {
    let urls: [URL]
    var height: CGFloat = 220
    var cornerRadius: CGFloat = 20

    /// `.scrollPosition(id:)` reports the centered page id as an optional.
    /// Keep it optional and derive a concrete index for the dots / accessibility.
    @State private var scrolledID: Int?

    private var currentIndex: Int {
        guard !urls.isEmpty else { return 0 }
        return min(max(scrolledID ?? 0, 0), urls.count - 1)
    }

    var body: some View {
        VStack(spacing: 14) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(Array(urls.enumerated()), id: \.offset) { index, url in
                        slide(url)
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1 : 0.92)
                                    .opacity(phase.isIdentity ? 1 : 0.7)
                            }
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrolledID)
            .frame(height: height)

            pageDots
        }
        .onAppear {
            // Establish an initial position so the first dot is highlighted.
            if scrolledID == nil { scrolledID = 0 }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Image carousel")
        .accessibilityValue("Image \(currentIndex + 1) of \(urls.count)")
    }

    private func slide(_ url: URL) -> some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeInOut(duration: 0.3))) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .transition(.opacity)
            case .failure:
                placeholder(systemImage: "photo.badge.exclamationmark")
            default:
                placeholder(systemImage: "photo")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipShape(.rect(cornerRadius: cornerRadius))
    }

    private func placeholder(systemImage: String) -> some View {
        ZStack {
            Rectangle().fill(.background.secondary)
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(.tertiary)
        }
    }

    private var pageDots: some View {
        HStack(spacing: 7) {
            ForEach(urls.indices, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Color.accentColor : Color.secondary.opacity(0.35))
                    .frame(width: index == currentIndex ? 20 : 7, height: 7)
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: currentIndex)
            }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    SnappingImageCarousel(urls: [
        URL(string: "https://picsum.photos/id/1015/800/500")!,
        URL(string: "https://picsum.photos/id/1025/800/500")!,
        URL(string: "https://picsum.photos/id/1035/800/500")!,
        URL(string: "https://picsum.photos/id/1043/800/500")!
    ])
    .padding()
}
