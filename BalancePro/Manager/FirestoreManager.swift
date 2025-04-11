import Foundation
import FirebaseFirestore

final class FirestoreManager {
  static let shared = FirestoreManager()
  private init() {}
  
  private let db = Firestore.firestore()
  
  func saveUser(uid: String, name: String, email: String, photoURL: String?, isEmailVerified: Bool) async throws {
    let userData: [String: Any] = [
      "uid": uid,
      "name": name,
      "email": email,
      "photoURL": photoURL ?? "",
      "isEmailVerified": isEmailVerified,
      "createdAt": FieldValue.serverTimestamp()
    ]
    
    try await db.collection("users").document(uid).setData(userData)
  }
}
