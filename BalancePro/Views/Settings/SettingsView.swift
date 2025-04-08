import SwiftUI

struct SettingsView: View {
  @ObservedObject var appState: AppState
  
  var body: some View {
    Button("Settings") {
      UserDefaults.standard.set(true, forKey: "isAuthenticated")
      appState.checkAppState()
    }
  }
}

#Preview {
  SettingsView(appState: .init())
}
