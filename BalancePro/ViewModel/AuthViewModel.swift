import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
  @Published var state: AuthState = .idle
  @Published var name = ""
  @Published var email = ""
  @Published var password = ""
  
  enum AuthState {
    case idle, registering, emailVerificationPending, authenticated
    case error(AuthError)
  }
  
  private let authService: AuthServiceProtocol
  private let userService: UserServiceProtocol
  
  init(authService: AuthServiceProtocol = AuthService(), userService: UserServiceProtocol = UserService()) {
    self.authService = authService
    self.userService = userService
  }
  
  func register() async {
    guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
      state = .error(.emptyEmailOrPassword)
      return
    }
    
    state = .registering
    
    do {
      let user = try await authService.register(email: email, password: password, name: name)
      try await authService.sendEmailVerification()
      state = .emailVerificationPending
      startEmailVerificationPolling(user: user)
    } catch {
      state = .error(AuthError(error: error))
    }
  }
  
  func login() async {
    guard !email.isEmpty, !password.isEmpty else {
      state = .error(.emptyEmailOrPassword)
      return
    }
    
    state = .registering
    
    do {
      let user = try await authService.login(email: email, password: password)
      if !user.isEmailVerified {
        state = .emailVerificationPending
        startEmailVerificationPolling(user: user)
      } else {
        try await userService.saveUser(user)
        state = .authenticated
      }
    } catch {
      state = .error(AuthError(error: error))
    }
  }
  
  private func startEmailVerificationPolling(user: User) {
    Task {
      while true {
        try await Task.sleep(nanoseconds: 5_000_000_000) // 5 sec.
        let isVerified = try await authService.checkEmailVerification()
        
        if isVerified {
          try await userService.saveUser(user)
          state = .authenticated
          break
        }
      }
    }
  }
}
