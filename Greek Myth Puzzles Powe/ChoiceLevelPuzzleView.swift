//
//  PuzzleView.swift
//  Olympus Glory Divine Powe
//
//  Created by Artur on 02.09.2024.
//

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
            
            VStack{
                HStack{
                    Button {
                        self.dismiss()
                    } label: {
                        Image("Group 3")
                    }.padding(.leading,20)
                    Text("Puzzle")
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
                
                
                ZStack{
                    Image("l1")
                    Button {
                        lev1.toggle()
                    } label: {
                        Image("Open")
                    }.padding(.leading,220)
                    
                }
                
                ZStack{
                    Image("l2")
                    Button {
                        if !booleanManager.retrieve(for: 0) {
                            if savedValue > 200 {
                                booleanManager.save(true, for: 0)
                                increaseAndSaveValue(by: -200) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            // Действие при переключении состояния lev2
                            lev2.toggle()
                        }
                    } label: {
                        // Меняем изображение в зависимости от состояния булевой переменной
                        Image(booleanManager.retrieve(for: 0) ? "Open" : "b1")
                    }
                    .padding(.leading, 220)
                }
                
                ZStack{
                    Image("l3")
                    Button {
                        if !booleanManager.retrieve(for: 1) {
                            if savedValue > 300 {
                                booleanManager.save(true, for: 1)
                                increaseAndSaveValue(by: -300) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            // Действие при переключении состояния lev2
                            lev3.toggle()
                        }
                    } label: {
                        Image(booleanManager.retrieve(for: 1) ? "Open" : "b2")
                    }.padding(.leading,220)
                }
                
                ZStack{
                    Image("l4")
                    Button {
                        if !booleanManager.retrieve(for: 2) {
                            if savedValue > 400 {
                                booleanManager.save(true, for: 2)
                                increaseAndSaveValue(by: -400) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            // Действие при переключении состояния lev2
                            lev4.toggle()
                        }
                       
                    } label: {
                        Image(booleanManager.retrieve(for: 2) ? "Open" : "b3")
                    }.padding(.leading,220)
                }
                
                ZStack{
                    Image("l5")
                    Button {
                        if !booleanManager.retrieve(for: 3) {
                            if savedValue > 500 {
                                booleanManager.save(true, for: 3)
                                increaseAndSaveValue(by: -500) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            // Действие при переключении состояния lev2
                            lev5.toggle()
                        }
                       
                    } label: {
                        Image(booleanManager.retrieve(for: 3) ? "Open" : "b4")
                    }.padding(.leading,220)
                }
                
                ZStack{
                    Image("l6")
                    Button {
                        if !booleanManager.retrieve(for: 4) {
                            if savedValue > 600 {
                                booleanManager.save(true, for: 4)
                                increaseAndSaveValue(by: -600) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            // Действие при переключении состояния lev2
                            lev6.toggle()
                        }
                    
                    } label: {
                        Image(booleanManager.retrieve(for: 4) ? "Open" : "b5")
                    }.padding(.leading,220)
                }
                
                ZStack{
                    Image("l7")
                    Button {
                        if !booleanManager.retrieve(for: 5) {
                            if savedValue > 700 {
                                booleanManager.save(true, for: 5)
                                increaseAndSaveValue(by: -700) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            // Действие при переключении состояния lev2
                            lev7.toggle()
                        }
                      
                    } label: {
                        Image(booleanManager.retrieve(for: 5) ? "Open" : "b6")
                    }.padding(.leading,220)
                }
                Spacer()
            }
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity)
            .fullScreenCover(isPresented: $lev1, content: {
                
                PuzzleGameLevel1View()
            })
            .fullScreenCover(isPresented: $lev2, content: {
                
                PuzzleGameLevel2View()
            })
            .fullScreenCover(isPresented: $lev3, content: {
                
                PuzzleGameLevel3View()
            })
        
            .fullScreenCover(isPresented: $lev4, content: {
                PuzzleGameLevel4View()
            })
            .fullScreenCover(isPresented: $lev5, content: {
                PuzzleGameLevel5View()
            })
        
            .fullScreenCover(isPresented: $lev6, content: {
                PuzzleGameLevel6View()
            })
        
            .fullScreenCover(isPresented: $lev7, content: {
                PuzzleGameLevel7View()
            })
    }
    
    func increaseAndSaveValue(by amount: Int) {
        savedValue += amount
        UserDefaults.standard.set(savedValue, forKey: "myIntKey")
    }
}


#Preview {
    ChoiceLevelPuzzleView()
}
