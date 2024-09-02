import SwiftUI

struct PuzzleGameLevel3View: View {
    @State private var image1Position: CGPoint = .zero
    @State private var image2Position: CGPoint = .zero
    @State private var image3Position: CGPoint = .zero
    @State private var image4Position: CGPoint = .zero
    @State private var image5Position: CGPoint = .zero
    @State private var image6Position: CGPoint = .zero

    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var img1 = false
    @State private var img2 = false
    @State private var img3 = false
    @State private var img4 = false
    @State private var img5 = false
    @State private var img6 = false
    @State private var indexImg = 0
    
    @State private var timeRemaining = 30
    @State private var timerRunning = false
    @State private var timer: Timer?
    @State private var count = 0
    
    @State private var frames: [CGRect] = Array(repeating: .zero, count: 6)
    @State private var currentPartIndex = 0
    let puzzleParts = ["p1", "p3", "p2", "p5", "p4", "p7"]
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 6)
    @State private var placedParts: [Bool] = Array(repeating: false, count: 6)
    @Environment(\.dismiss) var dismiss
    @State private var currentOffset: CGSize = .zero
    @State private var currentFrame: CGRect = .zero
    @State private var movingFrame: CGRect = .zero

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
                updateAllFrames()
            }
            
            GeometryReader { globalGeometry in
                VStack {
                    HStack {
                        Button {
                            self.dismiss()
                        } label: {
                            Image("Group 3")
                        }
                        .padding(.leading, 20)
                        
                        Text("Level #3")
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
                    
                    ZStack { // Используем ZStack для единого пространства координат
                        Color.clear // Помогает занять всё пространство ZStack
                            .coordinateSpace(name: "global") // Назначаем пространство координат
                        
                        // Используем глобальные координаты внутри ZStack
                        VStack {
                            HStack {
                                VStack {
                                    Image(!img1 ? "blue_square" : puzzleParts[0])
                                        .resizable()
                                        .frame(width: 120, height: 60)
                                        .background(GeometryReader { geometry in
                                            let index = 0
                                            Color.clear
                                                .onAppear {
                                                    // Используем координатное пространство "global"
                                                    self.frames[index] = geometry.frame(in: .named("global"))
                                                    self.image1Position = self.frames[index].origin
                                                }
                                                .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                    self.frames[index] = newValue
                                                    self.image1Position = newValue.origin
                                                }
                                        })
                                    
                                    Image(!img2 ? "blue_square" : puzzleParts[1])
                                        .resizable()
                                        .frame(width: 120, height: 60)
                                        .background(GeometryReader { geometry in
                                            let index = 1
                                            Color.clear
                                                .onAppear {
                                                    self.frames[index] = geometry.frame(in: .named("global"))
                                                    self.image2Position = self.frames[index].origin
                                                }
                                                .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                    self.frames[index] = newValue
                                                    self.image2Position = newValue.origin
                                                }
                                        })
                                }
                                
                                Image(!img3 ? "blue_square" : puzzleParts[2])
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .background(GeometryReader { geometry in
                                        let index = 2
                                        Color.clear
                                            .onAppear {
                                                self.frames[index] = geometry.frame(in: .named("global"))
                                                self.image3Position = self.frames[index].origin
                                            }
                                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                self.frames[index] = newValue
                                                self.image3Position = newValue.origin
                                            }
                                    })
                            }
                            
                            HStack {
                                Image(!img4 ? "blue_square" : puzzleParts[3])
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .background(GeometryReader { geometry in
                                        let index = 3
                                        Color.clear
                                            .onAppear {
                                                self.frames[index] = geometry.frame(in: .named("global"))
                                                self.image4Position = self.frames[index].origin
                                            }
                                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                self.frames[index] = newValue
                                                self.image4Position = newValue.origin
                                            }
                                    })
                                VStack {
                                    Image(!img5 ? "blue_square" : puzzleParts[4])
                                        .resizable()
                                        .frame(width: 120, height: 60)
                                        .background(GeometryReader { geometry in
                                            let index = 4
                                            Color.clear
                                                .onAppear {
                                                    self.frames[index] = geometry.frame(in: .named("global"))
                                                    self.image5Position = self.frames[index].origin
                                                }
                                                .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                    self.frames[index] = newValue
                                                    self.image5Position = newValue.origin
                                                }
                                        })
                                    
                                    Image(!img6 ? "blue_square" : puzzleParts[5])
                                        .resizable()
                                        .frame(width: 120, height: 60)
                                        .background(GeometryReader { geometry in
                                            let index = 5
                                            Color.clear
                                                .onAppear {
                                                    self.frames[index] = geometry.frame(in: .named("global"))
                                                    self.image6Position = self.frames[index].origin
                                                }
                                                .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                    self.frames[index] = newValue
                                                    self.image6Position = newValue.origin
                                                }
                                        })
                                }
                            }
                        }
                        .padding(.top, 40)
                    }
                    
                    Text("Next:")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
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
                                                self.currentFrame = innerGeometry.frame(in: .named("global"))
                                            }
                                            .onChange(of: currentOffset) { _, _ in
                                                self.movingFrame = CGRect(
                                                    origin: CGPoint(
                                                        x: innerGeometry.frame(in: .named("global")).minX + currentOffset.width,
                                                        y: innerGeometry.frame(in: .named("global")).minY + currentOffset.height
                                                    ),
                                                    size: CGSize(width: 80, height: 80)
                                                )
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
                                            
                                            self.currentFrame = self.movingFrame
                                            
                                            let tolerance: CGFloat = 10
                                            let imagePositions = [image1Position, image2Position, image3Position, image4Position, image5Position, image6Position]
                                            
                                            print("Проверка пересечений с текущим индексом: \(currentPartIndex)")
                                            
                                            for (index, position) in imagePositions.enumerated() {
                                                print("Проверка пересечения: текущий индекс \(currentPartIndex), проверяемый индекс \(index)")
                                                
                                                let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
                                                
                                                if checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                                                    print("Пересечение найдено для индекса: \(index)")
                                                    if currentPartIndex == index {
                                                        switch index {
                                                        case 0: img1.toggle()
                                                        case 1: img2.toggle()
                                                        case 2: img3.toggle()
                                                        case 3: img4.toggle()
                                                        case 4: img5.toggle()
                                                        case 5: img6.toggle()
                                                        default: break
                                                        }
                                                        count += 1
                                                        currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
                                                        
                                                        if count == 6 {
                                                            stopTimer()
                                                        }
                                                    }
                                                    
                                                    positions[currentPartIndex] = .zero
                                                    currentOffset = .zero
                                                    placedParts[currentPartIndex] = true
                                                    
                                                    break
                                                }
                                            }
                                            
                                            if !placedParts[currentPartIndex] {
                                                positions[currentPartIndex] = currentOffset
                                            }
                                        }
                                )
                                .onAppear {
                                    updateAllFrames()
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
            }
            
            if count == 6 {
                VStack {
                    ZStack {
                        Image("win")
                        Button {
                            increaseAndSaveValue(by: 150)
                            self.dismiss()
                        } label: {
                            Image("home")
                        }
                        .padding(.top, 190)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("bacc").ignoresSafeArea())
            }
            
            if timeRemaining == 0 {
                VStack {
                    ZStack {
                        Image("over")
                        Button {
                            self.dismiss()
                        } label: {
                            Image("home")
                        }
                        .padding(.top, 160)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("bacc").ignoresSafeArea())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            startTimer()
        }
    }

    func updateAllFrames() {
        self.frames[0] = CGRect(origin: self.image1Position, size: CGSize(width: 80, height: 80))
        self.frames[1] = CGRect(origin: self.image2Position, size: CGSize(width: 80, height: 80))
        self.frames[2] = CGRect(origin: self.image3Position, size: CGSize(width: 80, height: 80))
        self.frames[3] = CGRect(origin: self.image4Position, size: CGSize(width: 80, height: 80))
        self.frames[4] = CGRect(origin: self.image5Position, size: CGSize(width: 80, height: 80))
        self.frames[5] = CGRect(origin: self.image6Position, size: CGSize(width: 80, height: 80))
    }

    func checkIntersectionWithTolerance(_ rect1: CGRect, _ rect2: CGRect, tolerance: CGFloat) -> Bool {
        let expandedRect1 = rect1.insetBy(dx: -tolerance, dy: -tolerance)
        return expandedRect1.intersects(rect2)
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
    PuzzleGameLevel3View()
}
