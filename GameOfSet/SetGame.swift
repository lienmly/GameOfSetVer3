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
    var selectedCards = [Int:Card.State]() // [cardID:Card.State]
    var currentDealCardNumber = 0
    var numberOfCardsCurrentlySelected = 0
    var threePositionsOfRecentlyMatchedCards = [Int]()
    var score = 0
    var firstCardSelectedTimeStamp = Date()
    var existingSetsOnScreen = [(Card, Card, Card)]()
    
    init() {
        createNewDeckOfCard()
    }
    
    func refreshGame() {
        // Reset all class variables
        cards = []
        dealCards = []
        selectedCards = [:]
        currentDealCardNumber = 0
        numberOfCardsCurrentlySelected = 0
        threePositionsOfRecentlyMatchedCards = []
        score = 0
        existingSetsOnScreen = []
        createNewDeckOfCard()
        dealCard(total: 12)
    }
    
    func dealCard(total numberOfDealCard: Int) {
//        currentDealCardNumber = numberOfDealCard
        for _ in 0..<numberOfDealCard {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            dealCards.append(cards.remove(at: randomIndex))
        }
        print("There are \(cards.count) cards left in the deck")
    }
    
    func selectCard(id cardUniqueIdentifier: Int) {
        if numberOfCardsCurrentlySelected < 3 {
            // If there were 3 previously matched cards, remove those, and replace with new 3
            var threeMatchedCardIDs = [Int]()
            for (cardID, cardsState) in selectedCards {
                if cardsState == .matched {
                    threeMatchedCardIDs.append(cardID)
                    selectedCards.removeValue(forKey: cardID)
                }
            }
            for id in threeMatchedCardIDs {
                if let index = dealCards.index(where: {$0.uniqueID == id}) {
                    threePositionsOfRecentlyMatchedCards.append(dealCards[index].positionOnScreen)
                    dealCards.remove(at: index)
                }
            }
            if threeMatchedCardIDs.count == 3 {
                print("3 cards just got matched!")
                dealCard(total: cards.count < 3 ? cards.count : 3)
            }
            
            // If there are 3 unmatched cards in the pile => remove them
            var numberOfUnmatchedCards = 0
            for (_, cardState) in selectedCards {
                if cardState == .notMatched {
                    numberOfUnmatchedCards += 1
                }
            }
            
            if numberOfUnmatchedCards == 3 {
                for (cardID, cardState) in selectedCards {
                    if cardState == .notMatched {
                        selectedCards.removeValue(forKey: cardID)
                    }
                }
            }
            // Select & Deselect
            if selectedCards[cardUniqueIdentifier] == nil { // Card is not in selectedCards => add to selected pile
                selectedCards[cardUniqueIdentifier] = .undecided
                numberOfCardsCurrentlySelected += 1
                if numberOfCardsCurrentlySelected == 1 {
                    firstCardSelectedTimeStamp = Date()
                }
            } else { // Card in the currently selected pile => deselect card
                selectedCards.removeValue(forKey: cardUniqueIdentifier)
                numberOfCardsCurrentlySelected -= 1
                score -= 1
            }
            
            // Check match
            if numberOfCardsCurrentlySelected == 3 {
                checkMatch()
            }
        }
    }
    
    func selectCardVer2(id cardUniqueIdentifier: Int) {
        // Select & Deselect
        if let cardIndex = dealCards.index(where: {$0.uniqueID == cardUniqueIdentifier}) {
            if dealCards[cardIndex].state == .undecided { dealCards[cardIndex].state = .unselected } else if dealCards[cardIndex].state == .unselected { dealCards[cardIndex].state = .undecided }
        }
    }
    
    func checkExistingSet() -> Bool {
        // Penalize pressing Deal 3 More Cards if there is a Set available in the visible cards
        for card1 in dealCards {
            for card2 in dealCards {
                for card3 in dealCards {
                    if card1.uniqueID != card2.uniqueID && card2.uniqueID != card3.uniqueID && card1.uniqueID != card3.uniqueID {
                        let card1State = selectedCards[card1.uniqueID]
                        let card2State = selectedCards[card2.uniqueID]
                        let card3State = selectedCards[card3.uniqueID]
                        if !(card1State == .matched || card2State == .matched || card3State == .matched) {
                            let isASet = isThreeCardASet(card0: card1, card1: card2, card2: card3)
                            if isASet {
                                existingSetsOnScreen.append((card1, card2, card3))
                            }
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
        for (cardID, cardState) in selectedCards {
            if cardState == .undecided {
                for card in dealCards {
                    if card.uniqueID == cardID {
                        threeToBeMatchedCards.append(card)
                    }
                }
            }
        }
        
        // Check match
        if threeToBeMatchedCards.count == 3 {
            print("Checking to see if the cards are matching.")
            let isASet = isThreeCardASet(card0: threeToBeMatchedCards[0], card1: threeToBeMatchedCards[1], card2: threeToBeMatchedCards[2])
            
            for card in threeToBeMatchedCards {
                if (isASet) {
                    selectedCards[card.uniqueID] = .matched
                    print("Matched!")
                } else {
                    print("Not Matched! :(")
                    selectedCards[card.uniqueID] = .notMatched
                }
            }
            
            // Set score
            if (isASet) {
                let timeToFindMatch = Date().timeIntervalSince(firstCardSelectedTimeStamp)
                switch timeToFindMatch {
                case 1..<5: score += 10
                case 5..<10: score += 6
                default: score += 3
                }
            } else {
                score -= 5
            }
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
