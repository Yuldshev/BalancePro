import SwiftUI
import SwiftfulLoadingIndicators

struct CustomButtonPressed: View {
  var title: String
  var isLoading: Bool
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      if isLoading {
        LoadingIndicator(animation: .threeBallsBouncing, color: .appLight, size: .small)
          .frame(maxWidth: .infinity)
          .frame(height: 60)
          .background(.appPink)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      } else {
        Text(title)
          .font(.system(size: 16, weight: .semibold))
          .foregroundStyle(.appLight)
          .lineLimit(1)
          .frame(maxWidth: .infinity)
          .frame(height: 60)
          .background(.appPink)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
    }
  }
}

#Preview {
  CustomButtonPressed(title: "Confirm", isLoading: true, action: {})
}
