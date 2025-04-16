import Foundation

final class FinanceViewModel: ObservableObject {
  @Published var selectedCurrency = "USD"
  @Published var selectedLanguage = "RU"
  @Published var startBudget = ""
  @Published var selectTheme = "Light"
  
  let currencies = ["USD", "RUB", "UZD"]
  let languages = ["EN", "RU", "UZ"]
  let threme = ["Light", "Dark"]
  
}
