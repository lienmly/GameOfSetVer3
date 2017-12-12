//
//  Card.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 11/29/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import Foundation

struct Card {
    let number: Number
    let symbol: Symbol
    let shading: Shading
    let color: Color
    let uniqueID: Int
    var state: State
    var positionOnScreen: Int
    
    enum Number: Int { case one, two, three
        static var all = [Number.one, .two, .three]
    }
    enum Symbol: Int { case one, two, three
        static var all = [Symbol.one, .two, .three]
    }
    enum Shading: Int { case one, two, three
        static var all = [Shading.one, .two, .three]
    }
    enum Color: Int { case one, two, three
        static var all = [Color.one, .two, .three]
    }
    enum State: Int { case matched, notMatched, undecided, unselected, removed
        static var all = [State.matched, .notMatched, .undecided, .unselected, .removed]
    }
    
    init(number: Number, symbol: Symbol, shading: Shading, color: Color, state: State) {
        uniqueID = Card.getUniqueIdentifier()
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
        self.state = state
        self.positionOnScreen = 0
    }
    
    init() {
        uniqueID = 0
        self.number = .one
        self.symbol = .one
        self.shading = .one
        self.color = .one
        self.state = .unselected
        self.positionOnScreen = 0
    }
    
    static var idFactory = 0
    static func getUniqueIdentifier() -> Int {
        idFactory += 1
        return idFactory
    }
}
