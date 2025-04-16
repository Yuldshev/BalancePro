import SwiftUI

struct SettingsView: View {
  @ObservedObject var appState: AppState
  @StateObject private var vm = FinanceViewModel()
  @State private var isLoading = false
  
  var body: some View {
    ZStack {
      Color.appBG.ignoresSafeArea()
      
      VStack(alignment: .leading) {
        Text("Настроим приложение")
          .font(.system(size: 38, weight: .semibold))
          .padding(.horizontal, 24)
        
        Form {
          Section(header: Text("Валюта")) {
            Picker("Выберите валюту:", selection: $vm.selectedCurrency) {
              ForEach(vm.currencies, id: \.self) { currency in
                Text(currency)
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
          
          Section(header: Text("Язык приложения")) {
            Picker("Выберите язык:", selection: $vm.selectedLanguage) {
              ForEach(vm.languages, id: \.self) { language in
                Text(language)
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
          
          Section(header: Text("Тема")) {
            Picker("Выберите тему:", selection: $vm.selectTheme) {
              ForEach(vm.threme, id: \.self) { threme in
                Image(systemName: threme == "Light" ? "sun.max.fill" : "moon.fill")
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
          
          Section(header: Text("Стартовый баланс")) {
            TextField("Введите сумму", text: $vm.startBudget)
              .keyboardType(.numberPad)
          }
        }
        
        CustomButtonPressed(title: "Сохранить", isLoading: isLoading) {
          isLoading = true
          UserDefaults.standard.set(true, forKey: "isSettings")
          
          withAnimation {
            appState.currentView = .home
          }
        }
        .padding(.horizontal, 24)
      }
    }
  }
}

#Preview {
  SettingsView(appState: .init())
}
