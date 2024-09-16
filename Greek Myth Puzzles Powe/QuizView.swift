//
//  QuizView.swift
//  Olympus Glory Divine Powe
//
//  Created by Artur on 04.09.2024.
//

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
        ZStack {
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
                HStack {
                    Button {
                        self.dismiss()
                    } label: {
                        Image("Group 3")
                    }
                    .padding(.leading, 20)
                    
                    Text("Quiz")
                        .foregroundColor(.white)
                        .font(.title.bold())
                    
                    Spacer()
                    
                    ZStack {
                        Image("balance")
                        Text("\(savedValue)")
                            .foregroundColor(.white)
                            .padding(.leading, 15)
                    }
                    .padding(.trailing, 30)
                }
                .padding(.top, 50)
                
                HStack {
                    Image("tabler-icon-clock-2")
                    Text("\(timeRemaining)")
                        .foregroundColor(.white)
                        .font(.title.bold())
                }
                .padding(.top, 20)
                
                Text("\(Questions.questions[numberQuestions])")
                    .foregroundColor(.white)
                    .font(.custom("Lalezar", size: 30))
                    .multilineTextAlignment(.center)
                    .padding(30)
                    .background(Color("bacQwi"))
                    .cornerRadius(20)
                    .padding(.top, 40)
                    .padding(.horizontal)
                
                HStack {
                    buttonWithDelay(index: 0, one: $one, two: $two, three: $thre)
                    buttonWithDelay(index: 1, one: $one2, two: $two2, three: $thre2)
                }
                
                HStack {
                    buttonWithDelay(index: 2, one: $one3, two: $two3, three: $thre3)
                    buttonWithDelay(index: 3, one: $one4, two: $two4, three: $thre4)
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
                    })
                } else {
                    resultOverlay(imageName: "over", action: {
                        stopTimer()
                        self.dismiss()
                    })
                }
            }
            
            if timeRemaining == 0 {
                resultOverlay(imageName: "over", action: {
                    stopTimer()
                    self.dismiss()
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            startTimer()
        }
    }
    
    // Создание кнопки с задержкой и переключением флагов
    func buttonWithDelay(index: Int, one: Binding<Bool>, two: Binding<Bool>, three: Binding<Bool>) -> some View {
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
                .font(.custom("Lalezar", size: 20))
                .multilineTextAlignment(.center)
                .padding(30)
        })
        .frame(width: 180, height: 100)
        .background(getBackgroundColor(index: index, one: one, two: two, three: three))
        .cornerRadius(20)
    }
    
    // Overlay для результата на весь экран
    func resultOverlay(imageName: String, action: @escaping () -> Void) -> some View {
        VStack {
            ZStack {
                Image(imageName)
                Button {
                    action()
                } label: {
                    Image("home")
                }
                .padding(.top, 190)
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
