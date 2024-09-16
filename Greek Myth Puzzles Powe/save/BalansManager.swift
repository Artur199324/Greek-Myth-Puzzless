//
//  BalansManager.swift
//  Olympus Glory Divine Powe
//
//  Created by Artur on 04.09.2024.
//

import Foundation

class BalansManager : ObservableObject{
    private let keys = [
        "bal1", "bal2", "bal3"
    ]
    
    // Опубликованные переменные для обновления UI при изменении значений
    @Published var booleans: [Bool]

    init() {
        // Инициализация значений из UserDefaults
        booleans = keys.map { UserDefaults.standard.bool(forKey: $0) }
    }

    // Сохранение значения булевой переменной
    func save(_ value: Bool, for index: Int) {
        guard index >= 0 && index < booleans.count else { return }
        booleans[index] = value
        UserDefaults.standard.set(value, forKey: keys[index])
    }

    // Извлечение значения булевой переменной
    func retrieve(for index: Int) -> Bool {
        guard index >= 0 && index < booleans.count else { return false }
        return booleans[index]
    }

    // Переключение значения булевой переменной (toggle)
    func toggle(for index: Int) {
        guard index >= 0 && index < booleans.count else { return }
        booleans[index].toggle()
        save(booleans[index], for: index)
    }
}
