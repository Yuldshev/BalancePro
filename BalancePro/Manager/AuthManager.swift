import Foundation
import FirebaseAuth

//MARK: - Model Auth
struct AuthModel {
  let uid: String
  let email: String?
  let photoURL: String?
  
  init(user: User) {
    self.uid = user.uid
    self.email = user.email
    self.photoURL = user.photoURL?.absoluteString
  }
}

//MARK: - AuthManager
final class AuthManager {
  static let shared = AuthManager()
  private init() {}
  
  func createUser(email: String, password: String) async throws -> AuthModel {
    let authData = try await Auth.auth().createUser(withEmail: email, password: password)
    return AuthModel(user: authData.user)
  }
  
  func getAuthUser() throws -> AuthModel {
    guard let user = Auth.auth().currentUser else { throw AuthError.userNotFound }
    return AuthModel(user: user)
  }
  
  func signInUser(email: String, password: String) async throws -> AuthModel {
    let authData = try await Auth.auth().signIn(withEmail: email, password: password)
    return AuthModel(user: authData.user)
  }
}
