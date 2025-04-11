import SwiftUI

struct SettingsView: View {
  @ObservedObject var appState: AppState
  
  var body: some View {
    Button("Settings") {
      appState.checkAppState()
    }
  }
}

#Preview {
  SettingsView(appState: .init())
}
