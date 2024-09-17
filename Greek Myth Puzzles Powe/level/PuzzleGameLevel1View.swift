import SwiftUI

struct PuzzleGameLevel1View: View {
    @State private var imagePositions: [CGPoint] = Array(repeating: .zero, count: 4)
    @State private var isFullScreenPresented = false
    @State private var restartViewID = UUID()

    @State private var imgStates: [Bool] = Array(repeating: false, count: 4)
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
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                        }
                        .padding(.leading, geometry.size.width * 0.05)

                        Text("Level #1")
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
                            ForEach(0..<2) { index in
                                puzzleTargetView(index: index, geometry: geometry)
                            }
                        }
                        HStack(spacing: geometry.size.width * 0.02) {
                            ForEach(2..<4) { index in
                                puzzleTargetView(index: index, geometry: geometry)
                            }
                        }
                    }
                    .padding(.top, geometry.size.height * 0.04)

                    Text("Next:")
                        .font(.system(size: geometry.size.width * 0.06, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.height * 0.02)

                    // Текущее изображение для перетаскивания с глобальными координатами
                    if currentPartIndex < puzzleParts.count {
                        GeometryReader { geo in
                            Image(puzzleParts[currentPartIndex])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
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

                                            let tolerance: CGFloat = 20 // Допуск для пересечения

                                            // Проходим по всем объектам и проверяем пересечение
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

                                                        // **Ensure currentPartIndex does not exceed array bounds**
                                                        if currentPartIndex >= puzzleParts.count {
                                                            currentPartIndex = puzzleParts.count
                                                        }

                                                        break
                                                    }
                                                }
                                            }

                                            // Проверяем, чтобы currentPartIndex не выходил за пределы массива
                                            if currentPartIndex < placedParts.count {
                                                // Если нет пересечения, оставляем изображение на текущей позиции
                                                if !placedParts[currentPartIndex] {
                                                    positions[currentPartIndex] = currentOffset
                                                }
                                            }
                                        }
                                )
                        }
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)

                        Spacer()
                    } else {
                        Spacer()
                    }
                }

                if count == puzzleParts.count {
                    ZStack {
                        Color("bacc")
                            .ignoresSafeArea()

                        VStack(spacing: geometry.size.height * 0.05) {
                        
                            Image("win")
                                .resizable()
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                                .clipped()
                           

                            Button {
                                increaseAndSaveValue(by: 150)
                                self.dismiss()
                            } label: {
                                Image("home")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.45) // Увеличено с 0.2 до 0.25
                            }
                            // Убираем или корректируем padding, так как используем spacing в VStack
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea()
                }

                if timeRemaining == 0 {
                    if timeRemaining == 0 {
                        ZStack {
                            Color("bacc")
                                .ignoresSafeArea()

                            VStack(spacing: geometry.size.height * 0.05) {
                                Image("over")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.9)
                                    .clipped()

                                Button {
                                    self.dismiss()
                                } label: {
                                    Image("home")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.45) // Увеличено с 0.2 до 0.25
                                }
                                // Убираем или корректируем padding, так как используем spacing в VStack
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                    }
                }            }
            .onAppear {
                startTimer() // Запуск таймера при появлении представления
            }
        }
    }

    // Вспомогательная функция для отображения цели пазла
    @ViewBuilder
    func puzzleTargetView(index: Int, geometry: GeometryProxy) -> some View {
        Image(!imgStates[index] ? "blue_square" : puzzleParts[index])
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            self.frames[index] = geo.frame(in: .global)
                            self.imagePositions[index] = geo.frame(in: .global).origin
                        }
                        .onChange(of: geo.frame(in: .global)) {_, newValue in
                            self.frames[index] = newValue
                            self.imagePositions[index] = newValue.origin
                        }
                }
            )
    }

    // Функция для обновления всех рамок объектов
    func updateAllFrames() {
        // Обновление всех позиций, чтобы быть уверенным, что все рамки обновлены правильно
        for index in 0..<4 {
            self.frames[index] = CGRect(origin: self.imagePositions[index], size: CGSize(width: 80, height: 80))
        }
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
