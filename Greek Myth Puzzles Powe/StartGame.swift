import SwiftUI

struct StartGame: View {
    @State private var isPuzzle = false
    @State private var isQuiz = false
    
    @Environment(\.dismiss) var dismiss
    @State private var savedBak: Int = {
        let initialValue = 1
        let key = "bac"
        // Проверяем, существует ли значение в UserDefaults
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
                // Фоновое изображение на весь экран
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
                    // Верхняя панель
                    HStack {
                        Button {
                            self.dismiss()
                        } label: {
                            Image("Group 3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                        }
                        .padding(.leading, geometry.size.width * 0.07)
                        
                        Text("Game")
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
                        .padding(.trailing, geometry.size.width * 0.07)
                    }
                    .padding(.top, geometry.size.height * 0.05)
                    
                    Spacer()
                    
                    // Блок с изображениями и кнопками
                    HStack(spacing: geometry.size.width * 0.05) {
                        VStack {
                            Image("Group 17")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.4)
                            Button(action: {
                                isPuzzle.toggle()
                            }, label: {
                                Image("start")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.2)
                            })
                            .padding(.top, -geometry.size.height * 0.05)
                        }
                        
                        VStack {
                            Image("Group 18")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.4)
                            Button(action: {
                                isQuiz.toggle()
                            }, label: {
                                Image("start")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.2)
                            })
                            .padding(.top, -geometry.size.height * 0.05)
                        }
                    }
                    .padding(.bottom, geometry.size.height * 0.5) // Опускаем блок ниже
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .fullScreenCover(isPresented: $isPuzzle, content: {
            ChoiceLevelPuzzleView()
        })
        .fullScreenCover(isPresented: $isQuiz, content: {
            QuizView()
        })
    }
}

#Preview {
    StartGame()
}
