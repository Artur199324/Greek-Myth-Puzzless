import SwiftUI

struct PuzzleGameLevel1View: View {
    @State private var image1Position: CGPoint = .zero
    @State private var image2Position: CGPoint = .zero
    @State private var image3Position: CGPoint = .zero
    @State private var image4Position: CGPoint = .zero
    
    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var img1 = false
    @State private var img2 = false
    @State private var img3 = false
    @State private var img4 = false
    @State private var indexImg = 0
    
    @State private var timeRemaining = 20 // Начальное время
    @State private var timerRunning = false // Флаг, чтобы отслеживать состояние таймера
    @State private var timer: Timer?
    @State private var count = 0
    
    @State private var frames: [CGRect] = Array(repeating: .zero, count: 4) // Рамки всех изображений
    @State private var currentPartIndex = 0 // Индекс текущей части изображения
    let puzzleParts = ["part1", "part2", "part3", "part4"] // Имена изображений частей
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 4) // Позиции частей
    @State private var placedParts: [Bool] = Array(repeating: false, count: 4) // Отслеживание размещённых частей
    @Environment(\.dismiss) var dismiss
    @State private var currentOffset: CGSize = .zero // Смещение текущей части
    @State private var currentFrame: CGRect = .zero // Рамка текущей части
    @State private var movingFrame: CGRect = .zero // Рамка во время перемещения

    @State private var savedBak: Int = {
        let initialValue = 1
        let key = "bac"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()
    
    @State private var savedValue: Int = {
        let initialValue = 500
        let key = "myIntKey"
        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(initialValue, forKey: key)
        }
        return UserDefaults.standard.integer(forKey: key)
    }()

    var body: some View {
        ZStack {
            // Фоновое изображение в зависимости от savedBak
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
            .onAppear {
                // Обновляем все рамки при появлении
                updateAllFrames()
            }
            
            VStack {
                // Верхняя панель с кнопкой и счетчиком
                HStack {
                    Button {
                        self.dismiss()
                    } label: {
                        Image("Group 3")
                    }
                    .padding(.leading, 20)
                    
                    Text("Level #1")
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
                
                HStack{
                    Image("tabler-icon-clock-2")
                    Text("\(timeRemaining)")
                        .foregroundColor(.white)
                        .font(.title.bold())
                }.padding(.top,20)
                // Сетка изображений
                VStack {
                    HStack {
                        // Первое изображение с индексом 0
                        Image(!img1 ? "blue_square" : puzzleParts[0] )
                            .resizable()
                            .frame(width: 120, height: 120)
                        
                            .background(GeometryReader { geometry in
                                let index = 0
                                Color.clear
                                    .onAppear {
                                        // Убедитесь, что рамки обновляются сразу и корректно
                                        self.frames[index] = geometry.frame(in: .global)
                                        self.image1Position = geometry.frame(in: .global).origin
                                        print("Координаты объекта 0: \(self.frames[index])")
                                    }
                                    .onChange(of: geometry.frame(in: .global)) { newValue ,_ in
                                        self.frames[index] = newValue
                                        self.image1Position = newValue.origin
                                        print("Обновленные координаты объекта 0: \(self.frames[index])")
                                    }
                            })
                        
                        // Второе изображение с индексом 1
                        Image(!img2 ? "blue_square" : puzzleParts[1] )
                            .resizable()
                            .frame(width: 120, height: 120)
                            .background(GeometryReader { geometry in
                                let index = 1
                                Color.clear
                                    .onAppear {
                                        self.frames[index] = geometry.frame(in: .global)
                                        self.image2Position = geometry.frame(in: .global).origin
                                        print("Координаты объекта 1: \(self.frames[index])")
                                    }
                                    .onChange(of: geometry.frame(in: .global)) { newValue,_ in
                                        self.frames[index] = newValue
                                        self.image2Position = newValue.origin
                                        print("Обновленные координаты объекта 1: \(self.frames[index])")
                                    }
                            })
                    }
                    
                    HStack {
                        // Третье изображение с индексом 2
                        Image(!img3 ? "blue_square" : puzzleParts[2] )
                            .resizable()
                            .frame(width: 120, height: 120)
                            .background(GeometryReader { geometry in
                                let index = 2
                                Color.clear
                                    .onAppear {
                                        self.frames[index] = geometry.frame(in: .global)
                                        self.image3Position = geometry.frame(in: .global).origin
                                        print("Координаты объекта 2: \(self.frames[index])")
                                    }
                                    .onChange(of: geometry.frame(in: .global)) { newValue,_ in
                                        self.frames[index] = newValue
                                        self.image3Position = newValue.origin
                                        print("Обновленные координаты объекта 2: \(self.frames[index])")
                                    }
                            })
                        
                        // Четвертое изображение с индексом 3
                        Image(!img4 ? "blue_square" : puzzleParts[3] )
                            .resizable()
                            .frame(width: 120, height: 120)
                            .background(GeometryReader { geometry in
                                let index = 3
                                Color.clear
                                    .onAppear {
                                        self.frames[index] = geometry.frame(in: .global)
                                        self.image4Position = geometry.frame(in: .global).origin
                                        print("Координаты объекта 3: \(self.frames[index])")
                                    }
                                    .onChange(of: geometry.frame(in: .global)) { newValue, _ in
                                        self.frames[index] = newValue
                                        self.image4Position = newValue.origin
                                        print("Обновленные координаты объекта 3: \(self.frames[index])")
                                    }
                            })
                    }
                }.padding(.top,40)
                
                Text("Next:")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding(.top,20)
                
                // Текущее изображение для перетаскивания с глобальными координатами
                if currentPartIndex < puzzleParts.count {
                    GeometryReader { geometry in
                        Image(puzzleParts[currentPartIndex])
                            .resizable()
                            .frame(width: 180, height: 180)
                            .offset(currentOffset)
                            .border(Color.orange, width: 2)
                            .background(
                                GeometryReader { innerGeometry in
                                    Color.clear
                                        .onAppear {
                                            self.currentFrame = innerGeometry.frame(in: .global)
                                        }
                                        .onChange(of: currentOffset) { _, _ in
                                            self.movingFrame = CGRect(
                                                origin: CGPoint(
                                                    x: innerGeometry.frame(in: .global).minX + currentOffset.width,
                                                    y: innerGeometry.frame(in: .global).minY + currentOffset.height
                                                ),
                                                size: CGSize(width: 80, height: 80)
                                            )
                                            print("Координаты текущего объекта (во время перемещения): \(self.movingFrame)")
                                        }
                                }
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        currentOffset = CGSize(width: value.translation.width + positions[currentPartIndex].width,
                                                               height: value.translation.height + positions[currentPartIndex].height)
                                    }
                                    .onEnded { value in
                                        positions[currentPartIndex].width += value.translation.width
                                        positions[currentPartIndex].height += value.translation.height
                                        currentOffset = positions[currentPartIndex]
                                        
                                        // Используем последние координаты во время движения для проверки при отпускании
                                        self.currentFrame = self.movingFrame
                                        print("Координаты текущего объекта (при отпускании): \(self.currentFrame)")
                                        
                                        let tolerance: CGFloat = 6 // Пониженный допуск для точного пересечения
                                        let imagePositions = [image1Position, image2Position, image3Position, image4Position]
                                        
                                        // Проходим по всем объектам и проверяем пересечение
                                        for (index, position) in imagePositions.enumerated() {
                                            // Создаем рамку для проверки пересечения
                                            let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
                                            
                                            // Проверка, чтобы не сравнивать с самим собой
                                            if checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                                                //                                                print("Текущее изображение \(currentPartIndex) пересеклось с изображением \(index)")
                                                //                                                print("Координаты текущего объекта: \(self.currentFrame)")
                                                //                                                print("Координаты объекта \(index): \(targetFrame)")
                                                
                                                if currentPartIndex == index{
                                                    if index == 0{
                                                        img1.toggle()
                                                        count += 1
                                                    } else if index == 1{
                                                        img2.toggle()
                                                        count += 1
                                                    } else if index == 2{
                                                        img3.toggle()
                                                        count += 1
                                                    } else if index == 3{
                                                        img4.toggle()
                                                        count += 1
                                                    }
                                                    currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
                                                    
                                                    if count == 4 {
                                                        stopTimer()
                                                    }
                                                    
                                                }
                                                // Сбрасываем позицию текущего изображения
                                                
                                                positions[currentPartIndex] = .zero
                                                currentOffset = .zero
                                                
                                                // Обозначаем текущее изображение как размещённое
                                                placedParts[currentPartIndex] = true
                                                // Переключаем на следующее изображение
                                                
                                                break
                                            }
                                        }
                                        
                                        // Если нет пересечения, оставляем изображение на текущей позиции
                                        if !placedParts[currentPartIndex] {
                                            positions[currentPartIndex] = currentOffset
                                        }
                                    }
                            )
                            .onAppear {
                                // Проверка пересечения при первом рендере
                                updateAllFrames() // Убедитесь, что обновляются все позиции перед проверкой
                                let tolerance: CGFloat = 10
                                for (index, frame) in frames.enumerated() {
                                    if checkIntersectionWithTolerance(currentFrame, frame, tolerance: tolerance) {
                                        print("Пересечение при инициализации с объектом \(index)")
                                    }
                                }
                            }
                    }
                    .frame(width: 180, height: 180)
                    
                  
                    Spacer()
                }
            }
            
            if count == 4{
               
                VStack{
                
                    ZStack{
                        Image("win")
                        Button {
                            increaseAndSaveValue(by: 150)
                          
                            self.dismiss()
                        } label: {
                            Image("home")
                        }.padding(.top,190)

                    }
        
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("bacc")
                        .ignoresSafeArea()
                    )
                
            }
            
            if timeRemaining == 0 {
                VStack{
                
                    ZStack{
                        Image("over")
                        Button {
                            self.dismiss()
                        } label: {
                            Image("home")
                        }.padding(.top,160)

                    }
        
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("bacc")
                        .ignoresSafeArea()
                    )
    
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
                    startTimer() // Запуск таймера при появлении представления
                }
    
    }

    // Функция для обновления всех рамок объектов
    func updateAllFrames() {
        // Обновление всех позиций, чтобы быть уверенным, что все рамки обновлены правильно
        self.frames[0] = CGRect(origin: self.image1Position, size: CGSize(width: 80, height: 80))
        self.frames[1] = CGRect(origin: self.image2Position, size: CGSize(width: 80, height: 80))
        self.frames[2] = CGRect(origin: self.image3Position, size: CGSize(width: 80, height: 80))
        self.frames[3] = CGRect(origin: self.image4Position, size: CGSize(width: 80, height: 80))
    }

    // Функция для проверки пересечения с учетом допустимого отклонения
    func checkIntersectionWithTolerance(_ rect1: CGRect, _ rect2: CGRect, tolerance: CGFloat) -> Bool {
        let expandedRect1 = rect1.insetBy(dx: -tolerance, dy: -tolerance)
        return expandedRect1.intersects(rect2)
    }
    
    func startTimer() {
           guard !timerRunning else { return } // Проверяем, что таймер не запущен
           timerRunning = true
           timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
               if timeRemaining > 0 {
                   timeRemaining -= 1 // Уменьшаем время на 1 каждую секунду
               } else {
                   timer.invalidate() // Останавливаем таймер
                   print("Таймер завершён") // Вывод сообщения в консоль
                   timerRunning = false
               }
           }
       }

       // Функция для остановки таймера
       func stopTimer() {
           timer?.invalidate() // Останавливаем таймер
           timer = nil // Обнуляем ссылку на таймер
           timerRunning = false
       }
    
    func increaseAndSaveValue(by amount: Int) {
           savedValue += amount
           UserDefaults.standard.set(savedValue, forKey: "myIntKey")
           print("Loaded value: \(savedValue)")
       }
}

#Preview {
    PuzzleGameLevel1View()
}
