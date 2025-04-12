import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol UserServiceProtocol {
  func saveUser(_ user: User) async throws
}

final class UserService: UserServiceProtocol {
  private let db = Firestore.firestore()
  
  func saveUser(_ user: User) async throws {
    let userData: [String: Any] = [
      "uid": user.uid,
      "name": user.displayName ?? "",
      "email": user.email ?? "",
      "isEmailVerified": user.isEmailVerified,
      "createdAt": FieldValue.serverTimestamp()
    ]
    
    try await db.collection("users").document(user.uid).setData(userData)
  }
}
