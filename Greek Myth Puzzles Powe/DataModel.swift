//
//  DataModel.swift
//  Greek Myth Puzzles Powe
//
//  Created by Artur on 13.09.2024.
//

import Foundation
import Combine

class DataModel: ObservableObject {
    @Published var add: String = ""
    @Published var newUser: Bool? = nil
}
