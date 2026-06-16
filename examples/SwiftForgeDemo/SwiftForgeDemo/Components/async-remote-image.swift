import SwiftUI

/// An AsyncImage wrapper with shimmer placeholder, fade-in success, and tappable retry on failure.
struct AsyncRemoteImage: View {
    let url: URL?
    var aspectRatio: CGFloat = 4.0 / 3.0
    var cornerRadius: CGFloat = 16
    var contentMode: ContentMode = .fill

    @State private var reloadToken = UUID()

    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeInOut(duration: 0.35))) { phase in
            switch phase {
            case .empty:
                AsyncRemoteImageShimmer()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            case .failure:
                failureView
            @unknown default:
                AsyncRemoteImageShimmer()
            }
        }
        .id(reloadToken)
        .aspectRatio(aspectRatio, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .clipShape(.rect(cornerRadius: cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(.separator.opacity(0.5), lineWidth: 0.5)
        }
    }

    private var failureView: some View {
        Button {
            reloadToken = UUID()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                    .font(.title2.weight(.semibold))
                Text("Tap to retry")
                    .font(.footnote.weight(.medium))
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background.secondary)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Image failed to load. Tap to retry.")
    }
}

/// A subtle animated shimmer used as a loading placeholder.
private struct AsyncRemoteImageShimmer: View {
    @State private var phase: CGFloat = -1

    var body: some View {
        Rectangle()
            .fill(.background.secondary)
            .overlay {
                GeometryReader { proxy in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.35), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: proxy.size.width * 0.6)
                    .offset(x: proxy.size.width * phase)
                    .blendMode(.plusLighter)
                }
            }
            .overlay {
                Image(systemName: "photo")
                    .font(.title)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.3).repeatForever(autoreverses: false)) {
                    phase = 1.6
                }
            }
            .accessibilityLabel("Loading image")
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            AsyncRemoteImage(url: URL(string: "https://picsum.photos/600/450"))
            AsyncRemoteImage(
                url: URL(string: "https://invalid.example/broken.jpg"),
                aspectRatio: 16.0 / 9.0
            )
            AsyncRemoteImage(url: nil, aspectRatio: 1)
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
