import SwiftUI
import WebKit

struct ContentView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var isWebViewHidden = true // Изначально скрываем WebView
    @State private var showButtons: Bool? = nil // Изначально неизвестно, показывать ли кнопки
    @State private var isLoading = true       // Изначально показываем прогресс-бар
    @State private var progress: Double = 0.0 // Прогресс загрузки
    @State private var webView: WKWebView? = nil
    @State private var showAlert = false
    @State private var showFullScreen = false
    @State private var showShop = false
    @State private var lastButtonTapDate: Date? = UserDefaults.standard.object(forKey: "lastButtonTapDate") as? Date
    @State private var isStartGame = false
    @State private var savedValue: Int = {
        let key = "myIntKey"
        let initialValue = 0
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()

    var body: some View {
        ZStack {
            VStack {
                if showButtons == true {
                    buttonContent // Вью с кнопками
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("splash")
                    .ignoresSafeArea()
            )
            .fullScreenCover(isPresented: $isStartGame) {
                StartGame()
            }
            .fullScreenCover(isPresented: $showFullScreen) {
                DailyBonusView()
            }
            .fullScreenCover(isPresented: $showShop) {
                ShopView()
            }

            // Прогресс-бар по центру
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
            }

            // WebView размещаем поверх всего остального
            if !isWebViewHidden {
                if let url = URL(string: dataModel.add) {
                    WebView(
                        url: url,
                        onPageStarted: { url in
                            print("Page started loading: \(url?.absoluteString ?? "Unknown URL")")
                        },
                        onPageFinished: { url in
                            print("Page finished loading: \(url?.absoluteString ?? "Unknown URL")")

                        
                            if let urlString = url?.absoluteString, urlString.contains("celestialcirdscuit") {
                                showButtons = true
                                isWebViewHidden = true
                            } else {
                                showButtons = false
                                isWebViewHidden = false
                            }

                            isLoading = false
                        },
                        onProgressChanged: { progress in
                            self.progress = progress
                            if progress == 1.0 {
                                isLoading = false
                            }
                        },
                        webView: $webView
                    )
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width > 100 && (webView?.canGoBack ?? false) {
                                    webView?.goBack()
                                }
                            }
                    )
                } else {
                    Text("Некорректный URL")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            handleNewUser()
        }
        .onReceive(dataModel.$newUser) { _ in
            handleNewUser()
        }
        .onReceive(dataModel.$add) { newValue in
            print("dataModel.add изменился: \(newValue)")
            // Добавляем проверку на dataModel.newUser
            if dataModel.newUser == true {
                if !newValue.isEmpty {
                    if let url = URL(string: newValue) {
                        if let webView = webView {
                            webView.load(URLRequest(url: url))
                        } else {
                            webView = WKWebView()
                            webView?.load(URLRequest(url: url))
                        }
                        isWebViewHidden = false
                        isLoading = true
                    } else {
                        print("Некорректный URL: \(newValue)")
                    }
                } else {
                    isWebViewHidden = true
                    isLoading = true
                }
            } else if dataModel.newUser == false {
                // Если newUser == false, не показываем WebView
                isWebViewHidden = true
                isLoading = false
                showButtons = true
            }
        }
    }

    private func handleNewUser() {
        if let newUser = dataModel.newUser {
            if newUser {
                // Если newUser == true, начинаем загрузку WebView
                isWebViewHidden = false
                isLoading = true
                showButtons = false

                // Инициируем загрузку, если dataModel.add уже установлен
                if !dataModel.add.isEmpty {
                    if let url = URL(string: dataModel.add) {
                        if let webView = webView {
                            webView.load(URLRequest(url: url))
                        } else {
                            webView = WKWebView()
                            webView?.load(URLRequest(url: url))
                        }
                    }
                }
            } else {
                // Если newUser == false, сразу показываем кнопки
                isWebViewHidden = true
                isLoading = false
                showButtons = true
            }
        } else {
            // Если newUser == nil, показываем прогресс-бар
            isWebViewHidden = true
            isLoading = true
            showButtons = false
        }
    }

    // Содержимое с кнопками
    private var buttonContent: some View {
        VStack {
            HStack {
                ZStack {
                    Image("balance")
                    Text("\(savedValue)")
                        .foregroundColor(.white)
                        .padding(.leading, 15)
                }
                .padding(.leading, 30)

                Spacer()

                Button {
                    showShop.toggle()
                } label: {
                    Image("shop")
                }
                .padding(.trailing, 40)
            }
            Spacer()
            HStack {
                Spacer()
                Button {
                    checkButtonTap()
                } label: {
                    Image("Group 9")
                }
                .padding(.trailing, 30)
                .padding(.bottom, 50)
            }

            Button {
                isStartGame.toggle()
            } label: {
                Image("Group 1")
            }
            .padding(.bottom, 40)
        }
    }

    private func checkButtonTap() {
        let currentDate = Date()
        let calendar = Calendar.current

        if let lastTapDate = lastButtonTapDate {
            if let difference = calendar.dateComponents([.day], from: lastTapDate, to: currentDate).day, difference >= 1 {
                proceedToFullScreen()
            } else {
                showAlert.toggle()
            }
        } else {
            proceedToFullScreen()
        }
    }

    private func proceedToFullScreen() {
        lastButtonTapDate = Date()
        UserDefaults.standard.set(lastButtonTapDate, forKey: "lastButtonTapDate")
        showFullScreen.toggle()
    }
}

// Кастомный модификатор для скрытия элементов
extension View {
    func isHidden(_ hidden: Bool) -> some View {
        self.opacity(hidden ? 0 : 1)
            .disabled(hidden)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataModel())
}
