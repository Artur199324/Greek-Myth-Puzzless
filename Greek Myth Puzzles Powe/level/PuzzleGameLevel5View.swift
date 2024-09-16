import SwiftUI

struct PuzzleGameLevel5View: View {
    @State private var image1Position: CGPoint = .zero
    @State private var image2Position: CGPoint = .zero
    @State private var image3Position: CGPoint = .zero
    @State private var image4Position: CGPoint = .zero
    @State private var image5Position: CGPoint = .zero
    @State private var image6Position: CGPoint = .zero
    @State private var image7Position: CGPoint = .zero
    @State private var image8Position: CGPoint = .zero
    @State private var image9Position: CGPoint = .zero
    @State private var image10Position: CGPoint = .zero
    @State private var image11Position: CGPoint = .zero
    @State private var image12Position: CGPoint = .zero

    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var img1 = false
    @State private var img2 = false
    @State private var img3 = false
    @State private var img4 = false
    @State private var img5 = false
    @State private var img6 = false
    @State private var img7 = false
    @State private var img8 = false
    @State private var img9 = false
    @State private var img10 = false
    @State private var img11 = false
    @State private var img12 = false
    @State private var indexImg = 0
    
    @State private var timeRemaining = 30
    @State private var timerRunning = false
    @State private var timer: Timer?
    @State private var count = 0
    
    @State private var frames: [CGRect] = Array(repeating: .zero, count: 12)
    @State private var currentPartIndex = 0
    let puzzleParts = ["e1", "e2", "e3", "e4", "e5", "e6", "e7", "e8", "e9", "e10", "e11", "e12"]
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 12)
    @State private var placedParts: [Bool] = Array(repeating: false, count: 12)
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
                        
                        Text("Level #5")
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
                    
                    ZStack {
                        Color.clear
                            .coordinateSpace(name: "global")
                        
                        VStack {
                            // Первая строка изображений
                            HStack {
                                Image(!img1 ? "blue_square" : puzzleParts[0])
                                    .resizable()
                                    .frame(width: 180, height: 80)
                                    .background(GeometryReader { geometry in
                                        let index = 0
                                        Color.clear
                                            .onAppear {
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
                                    .frame(width: 80, height: 80)
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
                                
                                Image(!img3 ? "blue_square" : puzzleParts[2])
                                    .resizable()
                                    .frame(width: 80, height: 80)
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
                            
                            // Вторая строка изображений
                            HStack {
                                Image(!img4 ? "blue_square" : puzzleParts[3])
                                    .resizable()
                                    .frame(width: 180, height: 80)
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
                                
                                Image(!img5 ? "blue_square" : puzzleParts[4])
                                    .resizable()
                                    .frame(width: 80, height: 80)
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
                                    .frame(width: 80, height: 80)
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
                            
                            // Третья строка изображений
                            HStack {
                                Image(!img7 ? "blue_square" : puzzleParts[6])
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .background(GeometryReader { geometry in
                                        let index = 6
                                        Color.clear
                                            .onAppear {
                                                self.frames[index] = geometry.frame(in: .named("global"))
                                                self.image7Position = self.frames[index].origin
                                            }
                                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                self.frames[index] = newValue
                                                self.image7Position = newValue.origin
                                            }
                                    })
                                
                                Image(!img8 ? "blue_square" : puzzleParts[7])
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .background(GeometryReader { geometry in
                                        let index = 7
                                        Color.clear
                                            .onAppear {
                                                self.frames[index] = geometry.frame(in: .named("global"))
                                                self.image8Position = self.frames[index].origin
                                            }
                                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                self.frames[index] = newValue
                                                self.image8Position = newValue.origin
                                            }
                                    })
                                
                                Image(!img9 ? "blue_square" : puzzleParts[8])
                                    .resizable()
                                    .frame(width: 180, height: 80)
                                    .background(GeometryReader { geometry in
                                        let index = 8
                                        Color.clear
                                            .onAppear {
                                                self.frames[index] = geometry.frame(in: .named("global"))
                                                self.image9Position = self.frames[index].origin
                                            }
                                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                self.frames[index] = newValue
                                                self.image9Position = newValue.origin
                                            }
                                    })
                            }
                            
                            // Четвертая строка изображений
                            HStack {
                                Image(!img10 ? "blue_square" : puzzleParts[9])
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .background(GeometryReader { geometry in
                                        let index = 9
                                        Color.clear
                                            .onAppear {
                                                self.frames[index] = geometry.frame(in: .named("global"))
                                                self.image10Position = self.frames[index].origin
                                            }
                                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                self.frames[index] = newValue
                                                self.image10Position = newValue.origin
                                            }
                                    })
                                
                                Image(!img11 ? "blue_square" : puzzleParts[10])
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .background(GeometryReader { geometry in
                                        let index = 10
                                        Color.clear
                                            .onAppear {
                                                self.frames[index] = geometry.frame(in: .named("global"))
                                                self.image11Position = self.frames[index].origin
                                            }
                                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                self.frames[index] = newValue
                                                self.image11Position = newValue.origin
                                            }
                                    })
                                
                                Image(!img12 ? "blue_square" : puzzleParts[11])
                                    .resizable()
                                    .frame(width: 180, height: 80)
                                    .background(GeometryReader { geometry in
                                        let index = 11
                                        Color.clear
                                            .onAppear {
                                                self.frames[index] = geometry.frame(in: .named("global"))
                                                self.image12Position = self.frames[index].origin
                                            }
                                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                                self.frames[index] = newValue
                                                self.image12Position = newValue.origin
                                            }
                                    })
                            }
                        }
                        .padding(.top, 0)
                    }.padding(0)
                    
                    Text("Next:")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding(.top, 0)
                    
                    if currentPartIndex < puzzleParts.count {
                        GeometryReader { geometry in
                            Image(puzzleParts[currentPartIndex])
                                .resizable()
                                .frame(width: 100, height: 100)
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
                                            let imagePositions = [
                                                image1Position, image2Position, image3Position,
                                                image4Position, image5Position, image6Position,
                                                image7Position, image8Position, image9Position,
                                                image10Position, image11Position, image12Position
                                            ]
                                            
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
                                                        case 6: img7.toggle()
                                                        case 7: img8.toggle()
                                                        case 8: img9.toggle()
                                                        case 9: img10.toggle()
                                                        case 10: img11.toggle()
                                                        case 11: img12.toggle()
                                                        default: break
                                                        }
                                                        count += 1
                                                        currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
                                                        
                                                        if count == 12 {
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
                        .frame(width: 100, height: 100)
                        
                        Spacer()
                    }
                    
                }
            }
            
            if count == 12 {
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
        for (index, position) in [
            image1Position, image2Position, image3Position,
            image4Position, image5Position, image6Position,
            image7Position, image8Position, image9Position,
            image10Position, image11Position, image12Position
        ].enumerated() {
            self.frames[index] = CGRect(origin: position, size: CGSize(width: 80, height: 80))
        }
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
    PuzzleGameLevel5View()
}
