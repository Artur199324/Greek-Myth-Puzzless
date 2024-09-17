import SwiftUI

struct PuzzleGameLevel4View: View {
    @State private var imagePositions: [CGPoint] = Array(repeating: .zero, count: 9)
    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var imgStates: [Bool] = Array(repeating: false, count: 9)
    @State private var indexImg = 0

    @State private var timeRemaining = 30
    @State private var timerRunning = false
    @State private var timer: Timer?
    @State private var count = 0

    @State private var frames: [CGRect] = Array(repeating: .zero, count: 9)
    @State private var currentPartIndex = 0
    let puzzleParts = ["q1", "q2", "q3", "q4", "q5", "q6", "q7", "q8", "q9"]
    @State private var positions: [CGSize] = Array(repeating: .zero, count: 9)
    @State private var placedParts: [Bool] = Array(repeating: false, count: 9)
    @Environment(\.dismiss) var dismiss
    @State private var currentOffset: CGSize = .zero
    @State private var currentFrame: CGRect = .zero

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
                    updateAllFrames()
                }

                VStack {
                    // Верхняя панель с кнопкой и счетчиком
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

                        Text("Level #4")
                            .foregroundColor(.white)
                            .font(.system(size: geometry.size.width * 0.06, weight: .bold))

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
                            .frame(width: geometry.size.width * 0.05)
                        Text("\(timeRemaining)")
                            .foregroundColor(.white)
                            .font(.system(size: geometry.size.width * 0.05, weight: .bold))
                    }
                    .padding(.top, geometry.size.height * 0.02)

                    // Сетка изображений
                    VStack(spacing: geometry.size.height * 0.02) {
                        HStack(spacing: geometry.size.width * 0.02) {
                            puzzleTargetView(index: 0, width: geometry.size.width * 0.3, height: geometry.size.width * 0.15, geometry: geometry)
                            puzzleTargetView(index: 1, width: geometry.size.width * 0.15, height: geometry.size.width * 0.15, geometry: geometry)
                            puzzleTargetView(index: 2, width: geometry.size.width * 0.15, height: geometry.size.width * 0.15, geometry: geometry)
                        }

                        HStack(spacing: geometry.size.width * 0.02) {
                            puzzleTargetView(index: 3, width: geometry.size.width * 0.3, height: geometry.size.width * 0.15, geometry: geometry)
                            puzzleTargetView(index: 4, width: geometry.size.width * 0.15, height: geometry.size.width * 0.15, geometry: geometry)
                            puzzleTargetView(index: 5, width: geometry.size.width * 0.15, height: geometry.size.width * 0.15, geometry: geometry)
                        }

                        HStack(spacing: geometry.size.width * 0.02) {
                            puzzleTargetView(index: 6, width: geometry.size.width * 0.3, height: geometry.size.width * 0.3, geometry: geometry)
                            VStack(spacing: geometry.size.height * 0.02) {
                                puzzleTargetView(index: 7, width: geometry.size.width * 0.3, height: geometry.size.width * 0.15, geometry: geometry)
                                puzzleTargetView(index: 8, width: geometry.size.width * 0.3, height: geometry.size.width * 0.15, geometry: geometry)
                            }
                        }
                    }
                    .padding(.top, geometry.size.height * 0.04)

                    Text("Next:")
                        .font(.system(size: geometry.size.width * 0.06, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.height * 0.02)

                    // Текущее изображение для перетаскивания
                    if currentPartIndex < puzzleParts.count {
                        GeometryReader { geo in
                            Image(puzzleParts[currentPartIndex])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2)
                                .offset(currentOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            currentOffset = CGSize(
                                                width: value.translation.width + positions[currentPartIndex].width,
                                                height: value.translation.height + positions[currentPartIndex].height
                                            )
                                        }
                                        .onEnded { value in
                                            positions[currentPartIndex].width += value.translation.width
                                            positions[currentPartIndex].height += value.translation.height
                                            currentOffset = positions[currentPartIndex]

                                            self.currentFrame = CGRect(
                                                origin: CGPoint(
                                                    x: geo.frame(in: .global).minX + currentOffset.width,
                                                    y: geo.frame(in: .global).minY + currentOffset.height
                                                ),
                                                size: geo.size
                                            )

                                            let tolerance: CGFloat = 20

                                            // Проверка пересечения
                                            for index in 0..<frames.count {
                                                let targetFrame = frames[index]

                                                if checkIntersectionWithTolerance(self.currentFrame, targetFrame, tolerance: tolerance) {
                                                    if currentPartIndex == index {
                                                        imgStates[index] = true
                                                        count += 1

                                                        if count == puzzleParts.count {
                                                            stopTimer()
                                                        }

                                                        // Сбрасываем позицию текущего изображения
                                                        positions[currentPartIndex] = .zero
                                                        currentOffset = .zero

                                                        // Обозначаем текущее изображение как размещённое
                                                        placedParts[currentPartIndex] = true
                                                        // Переключаем на следующее изображение
                                                        currentPartIndex += 1

                                                        // Проверяем, чтобы currentPartIndex не выходил за пределы массива
                                                        if currentPartIndex >= puzzleParts.count {
                                                            currentPartIndex = puzzleParts.count
                                                        }

                                                        break
                                                    }
                                                }
                                            }

                                            if currentPartIndex < placedParts.count {
                                                if !placedParts[currentPartIndex] {
                                                    positions[currentPartIndex] = currentOffset
                                                }
                                            }
                                        }
                                )
                        }
                        .frame(width: geometry.size.width * 0.2)

                        Spacer()
                    } else {
                        Spacer()
                    }
                }

                // Экран победы
                if count == puzzleParts.count {
                    ZStack {
                        Color("bacc")
                            .ignoresSafeArea()

                        VStack(spacing: geometry.size.height * 0.05) {
                            Image("win")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.9)

                            Button {
                                increaseAndSaveValue(by: 150)
                                self.dismiss()
                            } label: {
                                Image("home")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.25)
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea()
                }

                // Экран проигрыша
                if timeRemaining == 0 {
                    ZStack {
                        Color("bacc")
                            .ignoresSafeArea()

                        VStack(spacing: geometry.size.height * 0.05) {
                            Image("over")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.9)

                            Button {
                                self.dismiss()
                            } label: {
                                Image("home")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.25)
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea()
                }
            }
            .onAppear {
                startTimer()
            }
        }
    }

    // Вспомогательная функция для отображения цели пазла
    @ViewBuilder
    func puzzleTargetView(index: Int, width: CGFloat, height: CGFloat, geometry: GeometryProxy) -> some View {
        Image(!imgStates[index] ? "blue_square" : puzzleParts[index])
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            self.frames[index] = geo.frame(in: .global)
                            self.imagePositions[index] = geo.frame(in: .global).origin
                        }
                        .onChange(of: geo.frame(in: .global)) { _, newValue in
                            self.frames[index] = newValue
                            self.imagePositions[index] = newValue.origin
                        }
                }
            )
    }

    func updateAllFrames() {
        for index in 0..<9 {
            self.frames[index] = CGRect(origin: self.imagePositions[index], size: CGSize(width: 80, height: 80))
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
    PuzzleGameLevel4View()
}
