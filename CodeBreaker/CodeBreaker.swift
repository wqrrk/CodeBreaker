//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Wark on 08.10.2026.
//

import SwiftUI

typealias Peg = String


struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    static let missing: Peg = "clear"
    
    
    //challenge task: add themes
    static let autumnThemePegChoices: Array<Peg> = ["orange", "brown", "red", "yellow", "maroon", "gold", "rust", "olive"]
    static let kidThemePegChoices: Array<Peg> = ["red", "blue", "green", "yellow", "orange", "pink", "purple", "brown"]
    static let carThemePegChoices: [Peg] = [
        "🚗", "🚕", "🚙", "🏎️",
        "🚓", "🚑", "🚒", "🚚"
    ]
    static let faceThemePegChoices: [Peg] = [
        "😀", "😍", "😎", "🥶",
        "😡", "😭", "🤯", "🤡"
    ]
    
    static let emojiPegChoices: Set<Peg> = [
        "🚗", "🚕", "🚙", "🏎️",
        "🚓", "🚑", "🚒", "🚚",
        "😀", "😍", "😎", "🥶",
        "😡", "😭", "🤯", "🤡"
    ]
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in 0..<pegs.count {
            pegs[index] = pegChoices.randomElement() ?? Code.missing
        }
    }
    
    //вот это не выкупаю до конца
    var matches : [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results
    }
    
    //modify how many pegs are in the guessing game by changing pegsCount parameter
    init(kind: Kind = .unknown, pegsCount: Int = 6) {
        self.kind = kind
        pegs = Array(repeating: Code.missing, count: pegsCount)
    }
}


struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts = [Code]()
    let pegChoices: [Peg]
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
 
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        }
        else {
            guess.pegs[index] = pegChoices.first ?? Code.missing
        }
    }
    
    var hasAlreadyTriedCurrentGuess: Bool {
        return attempts.contains(where: { $0.pegs == guess.pegs } )
    }
    
    var isEmptyGuess: Bool {
        return guess.pegs.allSatisfy { $0 == Code.missing }
    }
    
    mutating func restart() {
        self = CodeBreaker()
    }
    
    init(pegsCount: Int = Int.random(in: 3...6)) {
        switch Int.random(in: 0...3) {
        case 0: pegChoices = Code.autumnThemePegChoices
        case 1: pegChoices = Code.kidThemePegChoices
        case 2: pegChoices = Code.carThemePegChoices
        case 3: pegChoices = Code.faceThemePegChoices
        default: pegChoices = []
        }
        self.masterCode = Code(kind: .master, pegsCount: pegsCount)
        self.guess = Code(kind: .guess, pegsCount: pegsCount)
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
}
