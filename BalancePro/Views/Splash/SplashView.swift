import SwiftUI
import Lottie

struct SplashView: View {
  @ObservedObject var appState: AppState
  
  var body: some View {
    ZStack {
      Color.appBG.ignoresSafeArea() 
      
      LottieView {
        try await DotLottieFile.named("logo")
      }
      .playing()
      .frame(width: 250, height: 250)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  SplashView(appState: .init())
}
