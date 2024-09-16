//
//  Questions.swift
//  Olympus Glory Divine Powe
//
//  Created by Artur on 04.09.2024.
//

import Foundation

struct Questions{
    
    static let questions = [
    "Who is the king of the Greek gods?",
    "Which Greek goddess is known as the goddess of wisdom and war?",
    "Who is the Greek god of the sea?",
    "Which Greek god is the messenger of the gods, known for his speed?",
    "Who is the Greek goddess of love and beauty?",
    "Which Greek god is known as the god of war?",
    "Who is the ruler of the underworld in Greek mythology?",
    "Which Greek goddess is associated with the hunt and the moon?",
    "Who is the Greek god of wine, revelry, and theater?",
    "Which Greek goddess is the queen of the gods and the goddess of marriage?"
    
    ]
    
    static var wordAnswer: [[String]] = [
        ["Poseidon", "Hades", "Zeus", "Apollo"],
        ["Aphrodite", "Hera", "Athena", "Apollo"],
        ["Apollo", "Poseidon", "Hermes", "Dionysus"],
        ["Ares", "Hephaestus", "Hermes", "Apollo"],
        ["Aphrodite", "Artemis", "Demeter", "Hestia"],
        ["Apollo", "Ares", "Hades", "Zeus"],
        ["Zeus", "Poseidon", "Hades", "Ares"],
        ["Demeter", "Hera", "Artemis", "Athena"],
        ["Hermes", "Hephaestus", "Dionysus", "Apollo"],
        ["Athena", "Hera", "Aphrodite", "Artemis"],
    ]
    
    
    static var wrong = [3,3,2,3,1,2,3,3,3,2]
    
}
