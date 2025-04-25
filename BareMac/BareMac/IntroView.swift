import SwiftUI

struct IntroView: View {
    @Binding var showIntro: Bool

    var body: some View {
        ZStack {
            // Subtle radial gradient background
            RadialGradient(gradient: Gradient(colors: [Color(nsColor: .windowBackgroundColor), Color.black.opacity(0.4)]),
                           center: .center, startRadius: 50, endRadius: 800)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("BaremacLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .shadow(radius: 8)

                Text("Baremac")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.accentColor)

                Text("Version 0.2")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)

                Text("Developed by Mercha")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)

                Text("A minimal macOS tweak utility\nbuilt with SwiftUI.")
                    .font(.system(.subheadline, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)

                Button(action: {
                    withAnimation(.easeInOut) {
                        showIntro = false
                    }
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.black))
                        .foregroundColor(.white)
                        .shadow(radius: 6)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 10)
            }
            .padding()
        }
    }
}
