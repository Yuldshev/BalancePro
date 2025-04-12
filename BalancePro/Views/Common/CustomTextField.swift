import SwiftUI

struct CustomTextField: View {
  @Binding var text: String
  var placeholder: String
  var isSecure: Bool
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(placeholder)
        .font(.system(size: 12))
        .foregroundStyle(.appGray1)
      
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
          .textContentType(placeholder == "Email" ? .emailAddress : .none)
          .keyboardType(placeholder == "Email" ? .emailAddress : .default)
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .frame(height: 60)
    .background(.appLight)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

#Preview {
  CustomTextField(text: .constant("String"), placeholder: "Name", isSecure: false)
}
