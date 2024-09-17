import SwiftUI

struct ChoiceLevelPuzzleView: View {
    @State private var lev1 = false
    @State private var lev2 = false
    @State private var lev3 = false
    @State private var lev4 = false
    @State private var lev5 = false
    @State private var lev6 = false
    @State private var lev7 = false
    @StateObject private var booleanManager = BooleanManager()
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
        let initialValue = 1000 // Установите начальное значение, если необходимо
        let key = "myIntKey"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if savedBak == 1 {
                        Image("background 1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .ignoresSafeArea()
                    } else if savedBak == 2 {
                        Image("background 2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .ignoresSafeArea()
                    } else if savedBak == 3 {
                        Image("background 3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .ignoresSafeArea()
                    } else if savedBak == 4 {
                        Image("background 4")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
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
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                        }
                        .padding(.leading, geometry.size.width * 0.05)
                        
                        Text("Puzzle")
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
                    
                    ScrollView {
                        VStack(spacing: geometry.size.height * 0.02) {
                            ForEach(0..<7) { index in
                                levelButton(for: index, geometry: geometry)
                            }
                        }
                        .padding(.top, geometry.size.height * 0.02)
                    }
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .fullScreenCover(isPresented: $lev1) {
                PuzzleGameLevel1View()
            }
            .fullScreenCover(isPresented: $lev2) {
                PuzzleGameLevel2View()
            }
            .fullScreenCover(isPresented: $lev3) {
                PuzzleGameLevel3View()
            }
            .fullScreenCover(isPresented: $lev4) {
                PuzzleGameLevel4View()
            }
            .fullScreenCover(isPresented: $lev5) {
                PuzzleGameLevel5View()
            }
            .fullScreenCover(isPresented: $lev6) {
                PuzzleGameLevel6View()
            }
            .fullScreenCover(isPresented: $lev7) {
                PuzzleGameLevel7View()
            }
        }
    }
    
    @ViewBuilder
    private func levelButton(for index: Int, geometry: GeometryProxy) -> some View {
        let levelImages = ["l1", "l2", "l3", "l4", "l5", "l6", "l7"]
        let buttonImages = ["Open", "b1", "b2", "b3", "b4", "b5", "b6"]
        let costs = [0, 200, 300, 400, 500, 600, 700]
        let levelBindings = [$lev1, $lev2, $lev3, $lev4, $lev5, $lev6, $lev7]
        
        ZStack {
            Image(levelImages[index])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width * 0.8)
            
            Button {
                if !booleanManager.retrieve(for: index - 1) && index != 0 {
                    if savedValue >= costs[index] {
                        booleanManager.save(true, for: index - 1)
                        increaseAndSaveValue(by: -costs[index])
                    } else {
                        print("Недостаточно средств")
                        // Вы можете показать алерт пользователю здесь
                    }
                } else {
                    levelBindings[index].wrappedValue.toggle()
                }
            } label: {
                Image(booleanManager.retrieve(for: index - 1) || index == 0 ? "Open" : buttonImages[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.2)
            }
            .padding(.leading, geometry.size.width * 0.5)
        }
    }
    
    func increaseAndSaveValue(by amount: Int) {
        savedValue += amount
        UserDefaults.standard.set(savedValue, forKey: "myIntKey")
    }
}

#Preview {
    ChoiceLevelPuzzleView()
}
