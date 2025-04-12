import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
  func register(email: String, password: String, name: String) async throws -> User
  func login(email: String, password: String) async throws -> User
  func sendEmailVerification() async throws
  func checkEmailVerification() async throws -> Bool
}

final class AuthService: AuthServiceProtocol {
  func register(email: String, password: String, name: String) async throws -> User {
    let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
    let changeRequest = authResult.user.createProfileChangeRequest()
    changeRequest.displayName = name
    try await changeRequest.commitChanges()
    return authResult.user
  }
  
  func login(email: String, password: String) async throws -> User {
    let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
    return authResult.user
  }
  
  func sendEmailVerification() async throws {
    guard let user = Auth.auth().currentUser else { throw AuthError.userNotFound }
    try await user.sendEmailVerification()
  }
  
  func checkEmailVerification() async throws -> Bool {
    guard let user = Auth.auth().currentUser else { throw AuthError.userNotFound }
    try await user.reload()
    return user.isEmailVerified
  }
}
