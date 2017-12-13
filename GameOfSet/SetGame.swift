//
//  SetGame.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 11/29/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import Foundation

class SetGame {
    var cards = [Card]()
    var dealCards = [Card]()
    var numberOfCardsCurrentlySelected = 0
    var threePositionsOfRecentlyMatchedCards = [Int]()
    var score = 0
    var firstCardSelectedTimeStamp = Date()
    var existingSetsOnScreen = [(Card, Card, Card)]()
    
    init() {
        createNewDeckOfCard()
    }
    
    func refreshGame() {
        cards = []
        dealCards = []
        numberOfCardsCurrentlySelected = 0
        threePositionsOfRecentlyMatchedCards = []
        score = 0
        existingSetsOnScreen = []
        createNewDeckOfCard()
        dealCard(total: 12)
    }
    
    func dealCard(total numberOfDealCard: Int, sender tagNumber: Int = 0) {
        if tagNumber == 200 { score -= 1 } // Deal 3 more cards
        for _ in 0..<numberOfDealCard {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            dealCards.append(cards.remove(at: randomIndex))
        }
        print("There are \(cards.count) cards left in the deck")
    }
    
    func selectCardVer2(id cardUniqueIdentifier: Int) {
        if let cardIndex = dealCards.index(where: {$0.uniqueID == cardUniqueIdentifier}) {
            // Turn unmatched cards to .unselected
            var unmatchCount = 0
            dealCards.forEach({ if $0.state == .notMatched { unmatchCount += 1 }})
            if unmatchCount == 3 { for i in dealCards.indices { if dealCards[i].state == .notMatched { dealCards[i].state = .unselected }}}
            
            // Turn matched cards to .removed
            var matchCount = 0
            dealCards.forEach({ if $0.state == .matched { matchCount += 1 }})
            if matchCount == 3 {
                for _ in 0..<matchCount { if let matchedCardIndex = dealCards.index(where: { $0.state == .matched }) { dealCards[matchedCardIndex].state = .removed }}
            }
            
            // Select & Deselect
            if dealCards[cardIndex].state == .undecided {
                dealCards[cardIndex].state = .unselected
                numberOfCardsCurrentlySelected -= 1
            } else if dealCards[cardIndex].state == .unselected {
                dealCards[cardIndex].state = .undecided
                numberOfCardsCurrentlySelected += 1
                if numberOfCardsCurrentlySelected == 1 { firstCardSelectedTimeStamp = Date() }
            }
            
            // Check match
            if numberOfCardsCurrentlySelected == 3 {
                checkMatch()
            }
        }
    }
    
    func shuffleCurrentlyDisplayedCards() {
        var tempDealCard = [Card]()
        let numberOfDisplayedCards = dealCards.count
        for _ in 0..<numberOfDisplayedCards {
            let randomIndex = Int(arc4random_uniform(UInt32(dealCards.count)))
            let card = dealCards.remove(at: randomIndex)
            tempDealCard.append(card)
        }
        dealCards = tempDealCard
    }
    
    func removeMatchedCards() {
        var matchCount = 0
        dealCards.forEach({ if $0.state == .matched { matchCount += 1 }})
        if matchCount == 3 {
            for _ in 0..<matchCount {
                if let matchCardIndex = dealCards.index(where: { $0.state == .matched }) {
                    dealCards.remove(at: matchCardIndex)
                }
            }
        }
    }
    
    func checkExistingSet(sender tagNumber: Int) -> Bool {
        if tagNumber == 100 { score -= 2 } else if tagNumber == 200 { score -= 4 }// (1) Cheat (2) Deal 3 more cards
        if tagNumber == 200 {
            
        }
        for card1 in dealCards {
            for card2 in dealCards {
                for card3 in dealCards {
                    if card1.uniqueID != card2.uniqueID && card2.uniqueID != card3.uniqueID && card1.uniqueID != card3.uniqueID {
                        let isASet = isThreeCardASet(card0: card1, card1: card2, card2: card3)
                        if isASet {
                            existingSetsOnScreen.append((card1, card2, card3))
                        }
                    }
                }
            }
        }
        if existingSetsOnScreen.count > 0 {
            return true
        }
        return false
    }
    
    private func checkMatch() {
        // Gather the 3 cards we want to check if they match
        var threeToBeMatchedCards = [Card]()
        for card in dealCards {
            if card.state == .undecided {
                threeToBeMatchedCards.append(card)
            }
        }
        
        // Check match
        if threeToBeMatchedCards.count == 3 {
            print("Checking to see if the cards are matching.")
            let isASet = isThreeCardASet(card0: threeToBeMatchedCards[0], card1: threeToBeMatchedCards[1], card2: threeToBeMatchedCards[2])
            
            for index in dealCards.indices {
                if dealCards[index].state == .undecided {
                    if isASet {
                        dealCards[index].state = .matched; print("Matched!")
                    } else {
                        dealCards[index].state = .notMatched; print("Not Matched! :(")
                    }
                }
            }
            
            // Set score
            if (isASet) {
                let timeToFindMatch = Date().timeIntervalSince(firstCardSelectedTimeStamp)
                print("time interval = \(timeToFindMatch)")
                switch timeToFindMatch {
                case 0..<5: score += 10
                case 5..<10: score += 6
                default: score += 3
                }
            } else {
                score -= 5
            }
            print("score is now: \(score)")
            numberOfCardsCurrentlySelected = 0
        } else {
            print("There must be 3 unmatched cards to check the set rule.")
        }
    }
    
    private func isThreeCardASet(card0: Card, card1: Card, card2: Card) -> Bool {
        let isSameNumber = (card0.number == card1.number) && (card1.number == card2.number)
        let isDiffNumber = (card0.number != card1.number) && (card1.number != card2.number) && (card0.number != card2.number)
        let isSameSymbol = (card0.symbol == card1.symbol) && (card1.symbol == card2.symbol)
        let isDiffSymbol = (card0.symbol != card1.symbol) && (card1.symbol != card2.symbol) && (card0.symbol != card2.symbol)
        let isSameShading = (card0.shading == card1.shading) && (card1.shading == card2.shading)
        let isDiffShading = (card0.shading != card1.shading) && (card1.shading != card2.shading) && (card0.shading != card2.shading)
        let isSameColor = (card0.color == card1.color) && (card1.color == card2.color)
        let isDiffColor = (card0.color != card1.color) && (card1.color != card2.color) && (card0.color != card2.color)
        let isASet = (isSameNumber || isDiffNumber) && (isSameSymbol || isDiffSymbol) && (isSameShading || isDiffShading) && (isSameColor || isDiffColor)
        return isASet
    }
    
    private func createNewDeckOfCard () {
        // Add 81 cards in the deck
        for number in Card.Number.all {
            for symbol in Card.Symbol.all {
                for shading in Card.Shading.all {
                    for color in Card.Color.all {
                        cards.append(Card(number: number, symbol: symbol, shading: shading, color: color, state: .unselected))
                    }
                }
            }
        }
    }
}

extension String {
    func multiply(by numberOfRepeats: Int) -> String {
        var newString = ""
        for _ in 0...numberOfRepeats {
            newString += self
        }
        return newString
    }
}
