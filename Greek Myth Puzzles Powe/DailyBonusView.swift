import SwiftUI

struct DailyBonusView: View {
    @State private var present = false
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
                    
                    Text("Daily Bonus")
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
                
                Spacer()
                
                Image("img1")
                    .padding(.top, 50)
                Image("img2")
                
                Button(action: {
                    present.toggle()
                }, label: {
                    Image("img3")
                })
                .padding(.top, 50)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
            
            if present{
    
            VStack {
                ZStack {
                    Image("uuu")
                    Button {
                        increaseAndSaveValue(by: 150)
                        self.dismiss()
                    } label: {
                        Image("Group 1")
                    }
                    .padding(.top, 150)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("bacc")
                .ignoresSafeArea()
            )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
    }
    func increaseAndSaveValue(by amount: Int) {
           savedValue += amount
           UserDefaults.standard.set(savedValue, forKey: "myIntKey")
           print("Loaded value: \(savedValue)")
       }
}

#Preview {
    DailyBonusView()
}
