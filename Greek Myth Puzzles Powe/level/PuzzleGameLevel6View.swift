import SwiftUI

struct PuzzleGameLevel6View: View {
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
    @State private var image13Position: CGPoint = .zero
    @State private var image14Position: CGPoint = .zero

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
    @State private var img13 = false
    @State private var img14 = false
    @State private var indexImg = 0
    
    @State private var timeRemaining = 30
    @State private var timerRunning = false
    @State private var timer: Timer?
    @State private var count = 0
    
    @State private var frames: [CGRect] = Array(repeating: .zero, count: 14)
    @State private var currentPartIndex = 0
    let puzzleParts = ["f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12", "f13", "f14"]
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 14)
    @State private var placedParts: [Bool] = Array(repeating: false, count: 14)
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
                        
                        Text("Level #6")
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
                            // Первая строка изображений (4 элемента)
                            HStack {
                                ForEach(0..<4, id: \.self) { index in
                                    imageView(for: index, width: 80)
                                }
                            }
                            
                            // Вторая строка изображений (4 элемента)
                            HStack {
                                ForEach(4..<8, id: \.self) { index in
                                    imageView(for: index, width: 80)
                                }
                            }
                            
                            // Третья строка изображений (последний элемент шириной 180)
                            HStack {
                                ForEach(8..<10, id: \.self) { index in
                                    imageView(for: index, width: 80)
                                }
                                imageView(for: 10, width: 170)
                            }
                            
                            // Четвертая строка изображений (последний элемент шириной 180)
                            HStack {
                                ForEach(11..<13, id: \.self) { index in
                                    imageView(for: index, width: 80)
                                }
                                imageView(for: 13, width: 170)
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    Text("Next:")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
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
                                                image1Position, image2Position, image3Position, image4Position,
                                                image5Position, image6Position, image7Position, image8Position,
                                                image9Position, image10Position, image11Position, image12Position,
                                                image13Position, image14Position
                                            ]
                                            
                                            print("Проверка пересечений с текущим индексом: \(currentPartIndex)")
                                            
                                            for (index, position) in imagePositions.enumerated() {
                                                print("Проверка пересечения: текущий индекс \(currentPartIndex), проверяемый индекс \(index)")
                                                
                                                let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
                                                
                                                if checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                                                    print("Пересечение найдено для индекса: \(index)")
                                                    if currentPartIndex == index {
                                                        toggleImage(at: index)
                                                        count += 1
                                                        currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
                                                        
                                                        if count == 14 {
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
            
            if count == 14 {
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
    
    func imageView(for index: Int, width: CGFloat) -> some View {
        Image(!isImageToggled(index) ? "blue_square" : puzzleParts[index])
            .resizable()
            .frame(width: width, height: 80)
            .background(GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        self.frames[index] = geometry.frame(in: .named("global"))
                        self.updatePosition(for: index, with: self.frames[index].origin)
                    }
                    .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                        self.frames[index] = newValue
                        self.updatePosition(for: index, with: newValue.origin)
                    }
            })
    }
    
    func isImageToggled(_ index: Int) -> Bool {
        switch index {
        case 0: return img1
        case 1: return img2
        case 2: return img3
        case 3: return img4
        case 4: return img5
        case 5: return img6
        case 6: return img7
        case 7: return img8
        case 8: return img9
        case 9: return img10
        case 10: return img11
        case 11: return img12
        case 12: return img13
        case 13: return img14
        default: return false
        }
    }
    
    func toggleImage(at index: Int) {
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
        case 12: img13.toggle()
        case 13: img14.toggle()
        default: break
        }
    }
    
    func updatePosition(for index: Int, with origin: CGPoint) {
        switch index {
        case 0: image1Position = origin
        case 1: image2Position = origin
        case 2: image3Position = origin
        case 3: image4Position = origin
        case 4: image5Position = origin
        case 5: image6Position = origin
        case 6: image7Position = origin
        case 7: image8Position = origin
        case 8: image9Position = origin
        case 9: image10Position = origin
        case 10: image11Position = origin
        case 11: image12Position = origin
        case 12: image13Position = origin
        case 13: image14Position = origin
        default: break
        }
    }

    func updateAllFrames() {
        for (index, position) in [
            image1Position, image2Position, image3Position, image4Position,
            image5Position, image6Position, image7Position, image8Position,
            image9Position, image10Position, image11Position, image12Position,
            image13Position, image14Position
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
    PuzzleGameLevel6View()
}
