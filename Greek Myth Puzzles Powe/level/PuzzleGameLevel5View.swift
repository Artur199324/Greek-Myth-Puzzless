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
                        
                        Text("Level #5")
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
                            puzzleRow([img1, img2, img3], indices: [0, 1, 2], geometry: geometry)
                            puzzleRow([img4, img5, img6], indices: [3, 4, 5], geometry: geometry)
                            puzzleRow([img7, img8, img9], indices: [6, 7, 8], geometry: geometry)
                            puzzleRow([img10, img11, img12], indices: [9, 10, 11], geometry: geometry)
                        }
                    }
                    .padding(.top, geometry.size.height * 0.02)
                    
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
                                            let imagePositions = [
                                                image1Position, image2Position, image3Position,
                                                image4Position, image5Position, image6Position,
                                                image7Position, image8Position, image9Position,
                                                image10Position, image11Position, image12Position
                                            ]
                                            
                                            for (index, position) in imagePositions.enumerated() {
                                                let targetFrame = CGRect(origin: position, size: CGSize(width: 80, height: 80))
                                                
                                                if checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                                                    if currentPartIndex == index {
                                                        toggleImage(at: index)
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
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                        
                        Spacer()
                    }
                }
                
                if count == 12 {
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
    
    @ViewBuilder
    private func puzzleRow(_ images: [Bool], indices: [Int], geometry: GeometryProxy) -> some View {
        HStack(spacing: geometry.size.width * 0.02) {
            ForEach(0..<images.count, id: \.self) { index in
                Image(!images[index] ? "blue_square" : puzzleParts[indices[index]])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.25)
                    .background(GeometryReader { geometry in
                        let index = indices[index]
                        Color.clear
                            .onAppear {
                                self.frames[index] = geometry.frame(in: .named("global"))
                                switch index {
                                case 0: self.image1Position = self.frames[index].origin
                                case 1: self.image2Position = self.frames[index].origin
                                case 2: self.image3Position = self.frames[index].origin
                                case 3: self.image4Position = self.frames[index].origin
                                case 4: self.image5Position = self.frames[index].origin
                                case 5: self.image6Position = self.frames[index].origin
                                case 6: self.image7Position = self.frames[index].origin
                                case 7: self.image8Position = self.frames[index].origin
                                case 8: self.image9Position = self.frames[index].origin
                                case 9: self.image10Position = self.frames[index].origin
                                case 10: self.image11Position = self.frames[index].origin
                                case 11: self.image12Position = self.frames[index].origin
                                default: break
                                }
                            }
                            .onChange(of: geometry.frame(in: .named("global"))) { newValue, _ in
                                self.frames[index] = newValue
                            }
                    })
            }
        }
    }
    
    private func toggleImage(at index: Int) {
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
