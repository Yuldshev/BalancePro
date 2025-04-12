import SwiftUI
import SwiftfulLoadingIndicators

struct EmailVerificationView: View {
  let email: String
  
  var body: some View {
    VStack(spacing: 16) {
      Text("Подтвердите вашу почту")
        .font(.system(size: 38, weight: .semibold))
        .multilineTextAlignment(.center)
      Text("Мы отправили письмо на **\(email)**")
        .font(.system(size: 14))
      
      LoadingIndicator(animation: .fiveLinesWave, color: .accent, size: .medium)
        .frame(height: 100)
      
      Text("Проверяем статус подтверждения...")
        .font(.system(size: 12))
        .foregroundStyle(.appGray1)
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
    EmailVerificationView(email: "ikrom921@gmail.com")
}
