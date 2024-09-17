import SwiftUI

struct QuizView: View {
    @State private var numberQuestions = 0
    @State private var timeRemaining = 60 // Начальное время
    @State private var timerRunning = false // Флаг, чтобы отслеживать состояние таймера
    @State private var timer: Timer?
    @State private var count = 0
    @State private var wrong = 0
    @State private var one = false
    @State private var two = false
    @State private var thre = false
    
    @State private var one2 = false
    @State private var two2 = false
    @State private var thre2 = false
    
    @State private var one3 = false
    @State private var two3 = false
    @State private var thre3 = false
    
    @State private var one4 = false
    @State private var two4 = false
    @State private var thre4 = false
    
    @Environment(\.dismiss) var dismiss
    @State private var savedBak: Int = {
        let initialValue = 1
        let key = "bac"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    @State private var savedValue: Int = {
        let initialValue = 1000
        let key = "myIntKey"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фоновое изображение
                Group {
                    if savedBak == 1 {
                        Image("background 1")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    } else if savedBak == 2 {
                        Image("background 2")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    } else if savedBak == 3 {
                        Image("background 3")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    } else if savedBak == 4 {
                        Image("background 4")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    } else {
                        Color.black
                            .ignoresSafeArea()
                    }
                }
                
                VStack {
                    // Верхний бар с кнопкой назад, названием и балансом
                    HStack {
                        Button {
                            self.dismiss()
                        } label: {
                            Image("Group 3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                        }
                        .padding(.leading, geometry.size.width * 0.05)
                        
                        Text("Quiz")
                            .foregroundColor(.white)
                            .font(.system(size: geometry.size.width * 0.07, weight: .bold))
                        
                        Spacer()
                        
                        ZStack {
                            Image("balance")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15)
                            Text("\(savedValue)")
                                .foregroundColor(.white)
                                .padding(.leading, geometry.size.width * 0.02)
                        }
                        .padding(.trailing, geometry.size.width * 0.05)
                    }
                    .padding(.top, geometry.size.height * 0.05)
                    
                    // Таймер
                    HStack {
                        Image("tabler-icon-clock-2")
                        Text("\(timeRemaining)")
                            .foregroundColor(.white)
                            .font(.system(size: geometry.size.width * 0.06, weight: .bold))
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
                    // Вопрос
                    Text("\(Questions.questions[numberQuestions])")
                        .foregroundColor(.white)
                        .font(.custom("Lalezar", size: geometry.size.width * 0.07))
                        .multilineTextAlignment(.center)
                        .padding(30)
                        .background(Color("bacQwi"))
                        .cornerRadius(20)
                        .padding(.top, geometry.size.height * 0.05)
                        .padding(.horizontal)
                    
                    // Кнопки с ответами
                    HStack {
                        buttonWithDelay(index: 0, one: $one, two: $two, three: $thre, width: geometry.size.width, height: geometry.size.height)
                        buttonWithDelay(index: 1, one: $one2, two: $two2, three: $thre2, width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    HStack {
                        buttonWithDelay(index: 2, one: $one3, two: $two3, three: $thre3, width: geometry.size.width, height: geometry.size.height)
                        buttonWithDelay(index: 3, one: $one4, two: $two4, three: $thre4, width: geometry.size.width, height: geometry.size.height)
                    }
                    
                    Spacer()
                }
                
                // Full-screen overlays
                if numberQuestions == Questions.wrong.count - 1 {
                    if wrong >= 7 {
                        resultOverlay(imageName: "win", action: {
                            increaseAndSaveValue(by: 150)
                            stopTimer()
                            self.dismiss()
                        }, width: geometry.size.width, height: geometry.size.height)
                    } else {
                        resultOverlay(imageName: "over", action: {
                            stopTimer()
                            self.dismiss()
                        }, width: geometry.size.width, height: geometry.size.height)
                    }
                }
                
                if timeRemaining == 0 {
                    resultOverlay(imageName: "over", action: {
                        stopTimer()
                        self.dismiss()
                    }, width: geometry.size.width, height: geometry.size.height)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                startTimer()
            }
        }
    }
    
    // Создание кнопки с задержкой и переключением флагов
    func buttonWithDelay(index: Int, one: Binding<Bool>, two: Binding<Bool>, three: Binding<Bool>, width: CGFloat, height: CGFloat) -> some View {
        Button(action: {
            one.wrappedValue.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if Questions.wrong[numberQuestions] == index + 1 {
                    two.wrappedValue.toggle()
                    one.wrappedValue.toggle()
                    wrong += 1
                } else {
                    three.wrappedValue.toggle()
                    one.wrappedValue.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if Questions.wrong[numberQuestions] == index + 1 {
                        two.wrappedValue.toggle()
                    } else {
                        three.wrappedValue.toggle()
                    }
                    if numberQuestions < Questions.wrong.count - 1 {
                        numberQuestions += 1
                    }
                }
            }
        }, label: {
            Text("\(Questions.wordAnswer[numberQuestions][index])")
                .foregroundColor(.white)
                .font(.custom("Lalezar", size: width * 0.05))
                .multilineTextAlignment(.center)
                .padding(30)
        })
        .frame(width: width * 0.4, height: height * 0.1) // Размеры кнопок
        .background(getBackgroundColor(index: index, one: one, two: two, three: three))
        .cornerRadius(20)
    }
    
    // Overlay для результата на весь экран
    func resultOverlay(imageName: String, action: @escaping () -> Void, width: CGFloat, height: CGFloat) -> some View {
        VStack {
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.8)
                Button {
                    action()
                } label: {
                    Image("home")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.2)
                }
                .padding(.top, height * 0.2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bacc").ignoresSafeArea())
    }
    
    // Получение цвета фона кнопки в зависимости от состояния
    func getBackgroundColor(index: Int, one: Binding<Bool>, two: Binding<Bool>, three: Binding<Bool>) -> Color {
        if one.wrappedValue {
            return Color("bacQwi1")
        } else if two.wrappedValue {
            return Color("bacQwi2")
        } else if three.wrappedValue {
            return Color("bacQwi3")
        } else {
            return Color("bacQwi")
        }
    }
    
    func startTimer() {
        guard !timerRunning else { return }
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                print("Таймер завершён")
                timerRunning = false
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }
    
    func increaseAndSaveValue(by amount: Int) {
        savedValue += amount
        UserDefaults.standard.set(savedValue, forKey: "myIntKey")
        print("Loaded value: \(savedValue)")
    }
}

#Preview {
    QuizView()
}
