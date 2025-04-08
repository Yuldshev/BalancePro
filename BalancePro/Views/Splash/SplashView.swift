import SwiftUI
import Lottie

struct SplashView: View {
  @ObservedObject var appState: AppState
  
  var body: some View {
    VStack {
      LottieView {
        try await DotLottieFile.named("logo")
      }
      .playing()
      .frame(width: 250, height: 250)
      
    }
  }
}

#Preview {
  SplashView(appState: .init())
}
