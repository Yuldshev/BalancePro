import SwiftUI
import Firebase

@main
struct BalanceProApp: App {
  init() {
    FirebaseApp.configure()
  }
  var body: some Scene {
    WindowGroup {
      MainView()
    }
  }
}
