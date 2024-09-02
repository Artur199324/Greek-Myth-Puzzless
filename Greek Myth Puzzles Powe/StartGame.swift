import SwiftUI

struct StartGame: View {
    @State  private var isPuzzle = false
    @State  private var isQuiz = false
    
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
               
                HStack{
                    Button {
                        self.dismiss()
                    } label: {
                        Image("Group 3")
                    }.padding(.leading,20)
                    Text("Game")
                        .foregroundColor(.white)
                        .font(.title.bold())
                    Spacer()
                    ZStack{
                        Image("balance")
                        Text("\(savedValue)")
                            .foregroundColor(.white)
                            .padding(.leading,15)
                    }.padding(.trailing,30)
                }.padding(.top,50)
                
                
                HStack{
                    ZStack{
                        Image("Group 17")
                        Button(action: {
                            isPuzzle.toggle()
                        }, label: {
                            Image("start")
                        }
                        ).padding(.top,160)
                    }
                    
                    ZStack{
                        Image("Group 18")
                        Button(action: {
                            isQuiz.toggle()
                        }, label: {
                            Image("start")
                        }
                        ).padding(.top,160)
                    }
                }.padding(.top,30)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
