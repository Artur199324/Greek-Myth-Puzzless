//
//  ContentView.swift
//  Olympus Glory Divine Powe
//
//  Created by Artur on 02.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    @State private var showFullScreen = false
    @State private var showShope = false
    @State private var lastButtonTapDate: Date? = UserDefaults.standard.object(forKey: "lastButtonTapDate") as? Date
    @State private var isStartGame = false
    @State private var savedValue: Int = {
        let key = "myIntKey"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    var body: some View {
        VStack {
            HStack{
                ZStack{
                    Image("balance")
                    Text("\(savedValue)")
                        .foregroundColor(.white)
                        .padding(.leading,15)
                }.padding(.leading,30)
                Spacer()
                Button {
                    showShope.toggle()
                } label: {
                    Image("shop")
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text("Notification"), message: Text("You can only access this once per day."), dismissButton: .default(Text("OK")))
                }.padding(.trailing,40)
                
//                Button(action: {
//                    
//                }, label: {
//                    Image("sound")
//                }).padding(.trailing,20)
                
            }
            Spacer()
            HStack{
                Spacer()
                Button {
                    checkButtonTap()
                } label: {
                    Image("Group 9")
                }.padding(.trailing,30)
                    .padding(.bottom,50)
            }
            
            Button {
                isStartGame.toggle()
            } label: {
                Image("Group 1")
            }.padding(.bottom,40)
            
            
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity)
        .background(Image("splash")
            .ignoresSafeArea()
        )
        .fullScreenCover(isPresented: $isStartGame, content: {
            StartGame()
        })
        .fullScreenCover(isPresented: $showFullScreen, content: {
            DailyBonusView()
        })
        
        .fullScreenCover(isPresented: $showShope, content: {
            ShopView()
        })
    }
    
    private func checkButtonTap() {
          let currentDate = Date()
          let calendar = Calendar.current

          if let lastTapDate = lastButtonTapDate {
              // Check if more than 24 hours have passed since the last tap
              if let difference = calendar.dateComponents([.day], from: lastTapDate, to: currentDate).day, difference >= 1 {
                  proceedToFullScreen()
              } else {
                  // Less than a day has passed
                  showAlert.toggle()
              }
          } else {
              // First time tap
              proceedToFullScreen()
          }
      }
      
      private func proceedToFullScreen() {
          lastButtonTapDate = Date()
          UserDefaults.standard.set(lastButtonTapDate, forKey: "lastButtonTapDate")
          showFullScreen.toggle()
      }
}

#Preview {
    ContentView()
}
