import FirebaseAuth
import Foundation

enum AuthError: LocalizedError {
  case userNotFound
  case invalidEmail
  case emailAlreadyInUse
  case weakPassword
  case wrongPassword
  case emptyEmailOrPassword
  case emailVerificationSent
  case unknown(String)
  
  init(error: Error) {
    let code = (error as NSError).code
    switch code {
      case AuthErrorCode.userNotFound.rawValue:
        self = .userNotFound
      case AuthErrorCode.invalidEmail.rawValue:
        self = .invalidEmail
      case AuthErrorCode.emailAlreadyInUse.rawValue:
        self = .emailAlreadyInUse
      case AuthErrorCode.weakPassword.rawValue:
        self = .weakPassword
      case AuthErrorCode.wrongPassword.rawValue:
        self = .wrongPassword
      default:
        self = .unknown(error.localizedDescription)
    }
  }
  
  var errorDescription: String? {
    switch self {
      case .userNotFound:
        return "Пользователь не найден"
      case .invalidEmail:
        return "Неверный формат email"
      case .emailAlreadyInUse:
        return "Email уже используется"
      case .weakPassword:
        return "Слишком слабый пароль"
      case .wrongPassword:
        return "Неверный пароль"
      case .emptyEmailOrPassword:
        return "Введите email и пароль"
      case .emailVerificationSent:
        return "Письмо с подтверждением email отправлено"
      case .unknown(let message):
        return message
    }
  }
}
