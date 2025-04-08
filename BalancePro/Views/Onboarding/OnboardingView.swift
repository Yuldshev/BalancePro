import SwiftUI

struct OnboardingView: View {
  @ObservedObject var appState: AppState
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  OnboardingView(appState: .init())
}
