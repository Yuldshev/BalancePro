import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
  @Published var name = ""
  @Published var email = ""
  @Published var password = ""
  @Published var errorMessage = ""
  @Published var isLoading = false
  
  //MARK: - RegisterUser method
  func registerUser(appState: AppState) {
    guard !email.isEmpty, !password.isEmpty else {
      showError(.emptyEmailOrPassword)
      return
    }
    
    Task {
      do {
        isLoading = true
        let _ = try await AuthManager.shared.createUser(email: email, password: password)
        
        guard let user = Auth.auth().currentUser else {
          showError(.unknown("Подтвердите почту перед входом"))
          isLoading = false
          return
        }
        
        //MARK: - Change UserName
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = self.name
        try await changeRequest.commitChanges()
        
        if !user.isEmailVerified {
          try await user.sendEmailVerification()
          showError(.emailVerificationSent)
          isLoading = false
          return
        }
        
        //MARK: - Save Firestore
        try await FirestoreManager.shared.saveUser(
          uid: user.uid,
          name: self.name,
          email: user.email ?? "",
          photoURL: user.photoURL?.absoluteString ?? "",
          isEmailVerified: user.isEmailVerified
        )
        
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        appState.checkAppState()
        
      } catch {
        isLoading = false
        let authError = AuthError(error: error)
        showError(authError)
      }
    }
  }
  
  //MARK: - LoginUser method
  func loginUser(appState: AppState) {
    guard !email.isEmpty, !password.isEmpty else {
      showError(.emptyEmailOrPassword)
      return
    }
    
    Task {
      do {
        isLoading = true
        let _ = try await AuthManager.shared.signInUser(email: email, password: password)
        
        guard let _ = Auth.auth().currentUser else {
          showError(.unknown("Подтвердите почту перед входом"))
          isLoading = false
          return
        }
        
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        appState.checkAppState()
        
      } catch {
        isLoading = false
        let authError = AuthError(error: error)
        showError(authError)
      }
    }
  }
  
  //MARK: - Delegate error method
  func showError(_ error: AuthError) {
    errorMessage = error.localizedDescription
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.errorMessage = ""
    }
  }
}
