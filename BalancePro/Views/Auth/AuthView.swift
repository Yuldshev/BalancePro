import SwiftUI

//MARK: - AuthView
struct AuthView: View {
  @ObservedObject var appState: AppState
  @StateObject private var vm = AuthViewModel()
  @State private var isLogin = false
  
  var body: some View {
    ZStack {
      Color.appBG.ignoresSafeArea()
      
      VStack {
        switch vm.state {
          case .idle, .registering:
            AuthFormView(vm: vm, isLogin: $isLogin)
          case .emailVerificationPending:
            EmailVerificationView(email: vm.email)
          case .authenticated:
            SettingsView(appState: appState)
          case .error(let authError):
            AuthFormView(vm: vm, isLogin: $isLogin)
              .alert(authError.localizedDescription, isPresented: .constant(true)) {
                Button("Ok", role: .cancel) {
                  vm.state = .idle
                }
              }
        }
      }
    }
  }
}

//MARK: -  AuthFormView
struct AuthFormView: View {
  @ObservedObject var vm: AuthViewModel
  @Binding var isLogin: Bool
  @State private var isPressed = false
  @FocusState private var focused: Field?
  
  enum Field {
    case name, email, password
  }
  
  var body: some View {
    VStack {
      if isLogin {
        LoginView.transition(.blurReplace)
      } else {
        RegisterView.transition(.blurReplace)
      }
      PressButton
    }
    .padding(.horizontal, 24)
    .animation(.easeInOut, value: isLogin)
    .onAppear { focused = isLogin ? .email : .name }
  }
  
  private var RegisterView: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("Sign In")
        .font(.system(size: 38, weight: .semibold))
      
      VStack(spacing: 16) {
        CustomTextField(text: $vm.name, placeholder: "Name", isSecure: false)
          .focused($focused, equals: .name)
          .onSubmit { focused = .email }
        CustomTextField(text: $vm.email, placeholder: "Email", isSecure: false)
          .focused($focused, equals: .email)
          .onSubmit { focused = .password }
        CustomTextField(text: $vm.password, placeholder: "Password", isSecure: true)
          .focused($focused, equals: .password)
          .onSubmit { focused = nil }
      }
      .submitLabel(.next)
      
      CustomButtonPressed(title: "Создать", isLoading: isPressed) {
        Task {
          isPressed = true
          await vm.register()
        }
      }
    }
  }
  
  private var LoginView: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("Войди в аккаунт")
        .font(.system(size: 38, weight: .semibold))
      
      VStack(spacing: 16) {
        CustomTextField(text: $vm.email, placeholder: "Email", isSecure: false)
          .focused($focused, equals: .email)
          .onSubmit { focused = .password }
        CustomTextField(text: $vm.password, placeholder: "Password", isSecure: true)
          .focused($focused, equals: .password)
          .onSubmit { focused = nil }
      }
      .submitLabel(.next)
      
      CustomButtonPressed(title: "Log In", isLoading: isPressed) {
        Task {
          isPressed = true
          await vm.login()
        }
      }
    }
  }
  
  private var PressButton: some View {
    Button { isLogin.toggle() } label: {
      Text(isLogin ? "Регистрация" : "Уже есть аккаунт?")
        .foregroundStyle(.appGray1)
        .font(.system(size: 14, weight: .semibold))
      
    }
    .padding(.top, 8)
    .frame(maxWidth: .infinity, alignment: .trailing)
  }
}

//MARK: - Preview
#Preview {
  AuthView(appState: .init())
}

