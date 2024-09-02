//
//  ShopView.swift
//  Olympus Glory Divine Powe
//
//  Created by Artur on 04.09.2024.
//

import SwiftUI

struct ShopView: View {
  
    @StateObject private var booleanManager = BalansManager()
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
                    Text("Shop")
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
                    Image("baga1")
                    Button {
                        if !booleanManager.retrieve(for: 0) {
                            if savedValue > 200 {
                                booleanManager.save(true, for: 0)
                                increaseAndSaveValue(by: -200) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            saveBakValue(1)
                            self.dismiss()
                           
                        }
                    } label: {
                        // Меняем изображение в зависимости от состояния булевой переменной
                        Image(booleanManager.retrieve(for: 0) ? "apply" : "balance1")
                    }
                    .padding(.trailing, 200)
                    .padding(.top, 60)
                }
                
                ZStack{
                    Image("baga2")
                    Button {
                        if !booleanManager.retrieve(for: 1) {
                            if savedValue > 300 {
                                booleanManager.save(true, for: 1)
                                increaseAndSaveValue(by: -300) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            saveBakValue(2)
                            self.dismiss()
                            
                        }
                    } label: {
                        Image(booleanManager.retrieve(for: 1) ? "apply" : "balance2")
                    }.padding(.trailing, 200)
                        .padding(.top, 60)
                }
                
                ZStack{
                    Image("baga3")
                    Button {
                        if !booleanManager.retrieve(for: 2) {
                            if savedValue > 400 {
                                booleanManager.save(true, for: 2)
                                increaseAndSaveValue(by: -400) // Уменьшаем savedValue на 200
                            } else {
                                print("Недостаточно средств")
                            }
                        } else {
                            saveBakValue(3)
                            self.dismiss()
                          
                        }
                       
                    } label: {
                        Image(booleanManager.retrieve(for: 2) ? "apply" : "balance3")
                    }
                    .padding(.trailing, 200)
                    .padding(.top, 60)
                }
                
                
                Spacer()
            }
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity)
        
    }
    
    func increaseAndSaveValue(by amount: Int) {
        savedValue += amount
        UserDefaults.standard.set(savedValue, forKey: "myIntKey")
    }
    
    func saveBakValue(_ value: Int) {
           let key = "bac"
           UserDefaults.standard.set(value, forKey: key) // Сохраняем значение
           savedBak = value // Обновляем переменную состояния
       }
}

#Preview {
    ShopView()
}
