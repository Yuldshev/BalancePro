import SwiftUI

//MARK: - AuthView
struct AuthView: View {
  @ObservedObject var appState: AppState
  @StateObject private var vm = AuthViewModel()
  @State private var isLoading = false
  @State private var isLogin = false
  @FocusState private var focused: Field?
  
  
  var body: some View {
    ZStack {
      Color.appBG.ignoresSafeArea()
      
      VStack {
        ErrorMassageView
        Spacer()
        VStack {
          if isLogin {
            LoginUserView
              .transition(.blurReplace)
          } else {
            RegisterUserView
              .transition(.blurReplace)
          }
        }
        LoginButtonView
        Spacer()
      }
      .padding(.horizontal, 24)
      .animation(.easeInOut, value: isLogin)
    }
    .onAppear {
      focused = isLogin ? .email : .name
    }
  }
  
  //MARK: - RegisterUserView
  private var RegisterUserView: some View {
    VStack(alignment: .leading) {
      Text("Регистрация".capitalized)
        .font(.system(size: 38, weight: .semibold))
      
      VStack(spacing: 8) {
        CustomTextField(text: $vm.name, title: "Name", isSecure: false)
          .focused($focused, equals: .name)
          .onSubmit { focused = .email }
        CustomTextField(text: $vm.email, title: "Email", isSecure: false)
          .focused($focused, equals: .email)
          .onSubmit { focused = .password }
        CustomTextField(text: $vm.password, title: "Password", isSecure: true)
          .focused($focused, equals: .password)
          .onSubmit { focused = nil }
      }
      .submitLabel(.next)
      
      CustomBtnAction(title: "Создать", isLoading: vm.isLoading) {
        if !vm.isLoading {
          vm.registerUser(appState: appState)
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLogin = true
          }
        }
      }
      .padding(.top, 16)
    }
  }
  
  //MARK: - LoginUserView
  private var LoginUserView: some View {
    VStack(alignment: .leading) {
      Text("Вход".capitalized)
        .font(.system(size: 38, weight: .semibold))
      
      VStack(spacing: 8) {
        CustomTextField(text: $vm.email, title: "Email", isSecure: false)
          .focused($focused, equals: .email)
          .onSubmit { focused = .password }
        CustomTextField(text: $vm.password, title: "Password", isSecure: true)
          .focused($focused, equals: .password)
          .onSubmit { focused = nil }
      }
      .submitLabel(.next)
      
      CustomBtnAction(title: "Войти", isLoading: vm.isLoading) {
        if !vm.isLoading {
          vm.loginUser(appState: appState)
        }
      }
      .padding(.top, 16)
    }
  }
  
  //MARK: - ErrorMessageView
  private var ErrorMassageView: some View {
    VStack {
      Text(vm.errorMessage)
        .font(.system(size: 14))
        .foregroundStyle(.appLight)
        .lineLimit(2)
        .padding()
        .frame(maxWidth: .infinity)
        .background(.appPink)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 24)
        .transition(.move(edge: .top))
        .opacity(!vm.errorMessage.isEmpty ? 1 : 0)
          }
    .animation(.easeInOut, value: vm.errorMessage)
  }
  
  //MARK: - LoginButtonView
  private var LoginButtonView: some View {
    HStack {
      Spacer()
      Button {
        withAnimation {
          isLogin.toggle()
        }
      } label: {
        Text(isLogin ? "Регистрация" : "Уже есть аккаунт?")
          .foregroundStyle(.appGray1)
          .font(.system(size: 14, weight: .semibold))
      }
      .padding(.top, 8)
    }
    
    .padding(.horizontal, 24)
  }
}

//MARK: - Custom Views
struct CustomTextField: View {
  @Binding var text: String
  var title: String
  var isSecure: Bool
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.system(size: 12))
        .foregroundStyle(.appGray1 )
      if isSecure {
        SecureField("", text: $text)
          .font(.system(size: 16, weight: .semibold))
          .autocorrectionDisabled()
          .textContentType(.password)
      } else {
        TextField("", text: $text)
          .font(.system(size: 16, weight: .semibold))
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
          .textContentType(title == "Email" ? .emailAddress : .none)
          .keyboardType(title == "Email" ? .emailAddress : .default)
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .frame(height: 60)
    .background(.appLight)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

struct CustomBtnAction: View {
  var title: String
  var isLoading: Bool = false
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Group {
        if isLoading {
          ProgressView()
        } else {
          Text(title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.appLight)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .frame(height: 60)
    .background(.appPink)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

//MARK: - FocusField
enum Field {
  case name, email, password
}

//MARK: - Preview
#Preview {
  AuthView(appState: .init())
}
