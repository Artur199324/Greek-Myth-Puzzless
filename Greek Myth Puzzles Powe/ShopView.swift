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
            UserDefaults.standard.set(500, forKey: key) // Установите начальное значение, если его нет
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
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                        }
                        .padding(.leading, geometry.size.width * 0.05)
                        
                        Text("Shop")
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
                    
                 
                    
                    // Первый товар
                    shopItem(imageName: "baga1", balanceName: "balance1", index: 0, cost: 200, width: geometry.size.width, height: geometry.size.height)
                    
                    // Второй товар
                    shopItem(imageName: "baga2", balanceName: "balance2", index: 1, cost: 300, width: geometry.size.width, height: geometry.size.height)
                    
                    // Третий товар
                    shopItem(imageName: "baga3", balanceName: "balance3", index: 2, cost: 400, width: geometry.size.width, height: geometry.size.height)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func shopItem(imageName: String, balanceName: String, index: Int, cost: Int, width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.8)
            
            Button {
                if !booleanManager.retrieve(for: index) {
                    if savedValue >= cost {
                        booleanManager.save(true, for: index)
                        increaseAndSaveValue(by: -cost) // Уменьшаем savedValue на стоимость
                    } else {
                        print("Недостаточно средств")
                    }
                } else {
                    saveBakValue(index + 1)
                    self.dismiss()
                }
            } label: {
                Image(booleanManager.retrieve(for: index) ? "apply" : balanceName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width * 0.15)
            }
            .padding(.trailing, width * 0.3)
            .padding(.top, height * 0.03) // Уменьшено значение отступа сверху
        }
    }
    
    func increaseAndSaveValue(by amount: Int) {
        savedValue += amount
        UserDefaults.standard.set(savedValue, forKey: "myIntKey")
    }
    
    func saveBakValue(_ value: Int) {
        let key = "bac"
        UserDefaults.standard.set(value, forKey: key)
        savedBak = value
    }
}

#Preview {
    ShopView()
}
