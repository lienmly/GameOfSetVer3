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
    
    enum Number: Int {
        case one, two, three
        static var all = [Number.one, .two, .three]
    }
    
    enum Symbol: Int {
        case one, two, three
        static var all = [Symbol.one, .two, .three]
    }
    
    enum Shading: Int {
        case one, two, three
        static var all = [Shading.one, .two, .three]
    }
    
    enum Color: Int {
        case one, two, three
        static var all = [Color.one, .two, .three]
    }
}
