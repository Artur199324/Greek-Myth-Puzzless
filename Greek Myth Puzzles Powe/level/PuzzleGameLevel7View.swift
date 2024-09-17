import SwiftUI

struct PuzzleGameLevel7View: View {
    @State private var imagePositions: [CGPoint] = Array(repeating: .zero, count: 16)

    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var imageToggles: [Bool] = Array(repeating: false, count: 16)
    @State private var indexImg = 0
    
    @State private var timeRemaining = 30
    @State private var timerRunning = false
    @State private var timer: Timer?
    @State private var count = 0
    
    @State private var frames: [CGRect] = Array(repeating: .zero, count: 16)
    @State private var currentPartIndex = 0
    let puzzleParts = ["j1", "j2", "j3", "j4", "j5", "j6", "j7", "j8", "j9", "j10", "j11", "j12", "j13", "j14", "j15", "j16"]
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 16)
    @State private var placedParts: [Bool] = Array(repeating: false, count: 16)
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
                .onAppear {
                    updateAllFrames()
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
                        
                        Text("Level #7")
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
                    
                    HStack {
                        Image("tabler-icon-clock-2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.08)
                        Text("\(timeRemaining)")
                            .foregroundColor(.white)
                            .font(.system(size: geometry.size.width * 0.07, weight: .bold))
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
                    ZStack {
                        Color.clear
                            .coordinateSpace(name: "global")
                        
                        VStack(spacing: geometry.size.height * 0.02) {
                            // 4 строки по 4 элемента
                            ForEach(0..<4) { row in
                                HStack(spacing: geometry.size.width * 0.02) {
                                    ForEach(0..<4) { column in
                                        let index = row * 4 + column
                                        imageView(for: index, width: geometry.size.width * 0.2)
                                    }
                                }
                            }
                        }
                        .padding(.top, geometry.size.height * 0.02)
                    }
                    
                    Text("Next:")
                        .font(.system(size: geometry.size.width * 0.07, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.height * 0.02)
                    
                    if currentPartIndex < puzzleParts.count {
                        GeometryReader { geo in
                            Image(puzzleParts[currentPartIndex])
                                .resizable()
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
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
                                            let imagePositions = imagePositions
                                            
                                            for (index, position) in imagePositions.enumerated() {
                                                let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
                                                
                                                if checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                                                    if currentPartIndex == index {
                                                        toggleImage(at: index)
                                                        count += 1
                                                        currentPartIndex = (currentPartIndex + 1) % puzzleParts.count
                                                        
                                                        if count == 16 {
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
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                        
                        Spacer()
                    }
                }
                
                if count == 16 {
                    winOverlay(geometry: geometry)
                }
                
                if timeRemaining == 0 {
                    gameOverOverlay(geometry: geometry)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                startTimer()
            }
        }
    }
    
    func imageView(for index: Int, width: CGFloat) -> some View {
        Image(!isImageToggled(index) ? "blue_square" : puzzleParts[index])
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: width)
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
    
    private func winOverlay(geometry: GeometryProxy) -> some View {
        VStack {
            ZStack {
                Image("win")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8)
                Button {
                    increaseAndSaveValue(by: 150)
                    self.dismiss()
                } label: {
                    Image("home")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.2)
                }
                .padding(.top, geometry.size.height * 0.25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bacc").ignoresSafeArea())
    }
    
    private func gameOverOverlay(geometry: GeometryProxy) -> some View {
        VStack {
            ZStack {
                Image("over")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8)
                Button {
                    self.dismiss()
                } label: {
                    Image("home")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.2)
                }
                .padding(.top, geometry.size.height * 0.25)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bacc").ignoresSafeArea())
    }
    
    func isImageToggled(_ index: Int) -> Bool {
        return imageToggles[index]
    }
    
    func toggleImage(at index: Int) {
        imageToggles[index].toggle()
    }
    
    func updatePosition(for index: Int, with origin: CGPoint) {
        imagePositions[index] = origin
    }

    func updateAllFrames() {
        for (index, position) in imagePositions.enumerated() {
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
    PuzzleGameLevel7View()
}
