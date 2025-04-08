import SwiftUI

struct AuthView: View {
  @ObservedObject var appState: AppState
  
  var body: some View {
    Button("Auth") {
      appState.checkAppState()
    }
  }
}

#Preview {
  AuthView(appState: .init())
}
