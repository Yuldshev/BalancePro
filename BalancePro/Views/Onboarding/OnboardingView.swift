import SwiftUI
import Lottie

//MARK: - MainView
struct OnboardingView: View {
  @ObservedObject var appState: AppState
  @State private var indicator = 0
  @State private var swipeDirection: SwipeDirection = .left
  
  let onboardList = [
    ("Твои деньги под контролем", "Следи за финансами просто и без стресса. Мы всегда рядом!", "shape1"),
    ("Записывай траты на лету", "Пара секунд — и покупка уже в списке. Легко, как отправить сообщение.", "shape2"),
    ("Смотри, куда уходят деньги", "Яркая статистика покажет всё как на ладони. Планировать стало ещё проще!", "shape3")
  ]
  
  var body: some View {
    VStack {
      ForEach(0..<onboardList.count, id: \.self) { screen in
        if screen == indicator {
          OnboardingScreen(
            header: onboardList[screen].0,
            subheader: onboardList[screen].1,
            lottie: onboardList[screen].2
          )
          .transition(.move(edge: swipeDirection == .left ? .trailing : .leading))
          .id(indicator)
        }
      }
    }
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .safeAreaInset(edge: .bottom) {
      HStack {
        IndicatorView(currentIndex: indicator)
        Spacer()
        NextCustomBtn(isFinish: indicator < onboardList.count - 1) {
          withAnimation(.easeOut) {
            if indicator < onboardList.count - 1 {
              swipeDirection = .left
              indicator += 1
            } else {
              UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
              appState.checkAppState()
            }
          }
        }
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 40)
    }
    .gesture(
      DragGesture()
        .onEnded { value in
          let threshold: CGFloat = 50
          withAnimation(.easeInOut) {
            if value.translation.width < -threshold {
              if indicator < onboardList.count - 1 {
                swipeDirection = .left
                indicator += 1
              }
            } else if value.translation.width > threshold {
              if indicator > 0 {
                swipeDirection = .right
                indicator -= 1
              }
            }
          }
        }
    )
  }
}

//MARK: - SupportView
struct OnboardingScreen: View {
  var header: String
  var subheader: String
  var lottie: String
  
  var body: some View {
    VStack {
      AnimationView(name: lottie)
        .padding(.bottom, 30)
      VStack(alignment: .leading, spacing: 30) {
        Text(header)
          .font(.system(size: 38, weight: .semibold))
        Text(subheader)
          .font(.system(size: 14))
          .lineSpacing(6.3)
      }
    }
  }
}

struct AnimationView: View {
  @State private var shouldLoad = false
  
  var name: String
  
  var body: some View {
    VStack {
      LottieView {
        try await DotLottieFile.named(name)
      }
      .playing()
    }
    .frame(maxWidth: 346, maxHeight: 346)
  }
}

struct IndicatorView: View {
  var currentIndex: Int
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<3, id: \.self) { index in
        Circle()
          .frame(width: 12, height: 12)
          .foregroundStyle(index == currentIndex ? .appLight : .appGray2)
      }
    }
  }
}

struct NextCustomBtn: View {
  var isFinish: Bool
  var action: () -> Void
  
  var body: some View {
    Button(action: action) {
      if isFinish {
        Image(systemName: "arrow.right")
          .bold()
      } else {
        Image(systemName: "checkmark")
          .bold()
      }
    }
    .frame(width: 56, height: 56)
    .background(.appLight)
    .clipShape(Circle())
  }
}

//MARK: - Direction
enum SwipeDirection {
    case left, right
}

//MARK: - Preview
#Preview {
  OnboardingView(appState: .init())
    .background(.appBG).ignoresSafeArea()
}
