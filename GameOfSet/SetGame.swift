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
        createNewDeckOfCard()
        dealCard(total: 12)
    }
    
    func dealCard(total numberOfDealCard: Int) {
        currentDealCardNumber = numberOfDealCard
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
            let isSameNumber = (threeToBeMatchedCards[0].number == threeToBeMatchedCards[1].number) && (threeToBeMatchedCards[1].number == threeToBeMatchedCards[2].number)
            let isDiffNumber = (threeToBeMatchedCards[0].number != threeToBeMatchedCards[1].number) && (threeToBeMatchedCards[1].number != threeToBeMatchedCards[2].number) && (threeToBeMatchedCards[0].number != threeToBeMatchedCards[2].number)
            let isSameSymbol = (threeToBeMatchedCards[0].symbol == threeToBeMatchedCards[1].symbol) && (threeToBeMatchedCards[1].symbol == threeToBeMatchedCards[2].symbol)
            let isDiffSymbol = (threeToBeMatchedCards[0].symbol != threeToBeMatchedCards[1].symbol) && (threeToBeMatchedCards[1].symbol != threeToBeMatchedCards[2].symbol) && (threeToBeMatchedCards[0].symbol != threeToBeMatchedCards[2].symbol)
            let isSameShading = (threeToBeMatchedCards[0].shading == threeToBeMatchedCards[1].shading) && (threeToBeMatchedCards[1].shading == threeToBeMatchedCards[2].shading)
            let isDiffShading = (threeToBeMatchedCards[0].shading != threeToBeMatchedCards[1].shading) && (threeToBeMatchedCards[1].shading != threeToBeMatchedCards[2].shading) && (threeToBeMatchedCards[0].shading != threeToBeMatchedCards[2].shading)
            let isSameColor = (threeToBeMatchedCards[0].color == threeToBeMatchedCards[1].color) && (threeToBeMatchedCards[1].color == threeToBeMatchedCards[2].color)
            let isDiffColor = (threeToBeMatchedCards[0].color != threeToBeMatchedCards[1].color) && (threeToBeMatchedCards[1].color != threeToBeMatchedCards[2].color) && (threeToBeMatchedCards[0].color != threeToBeMatchedCards[2].color)
            let isASet = (isSameNumber || isDiffNumber) && (isSameSymbol || isDiffSymbol) && (isSameShading || isDiffShading) && (isSameColor || isDiffColor)
            
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
                score += 3
            } else {
                score -= 5
            }
            numberOfCardsCurrentlySelected = 0
        } else {
            print("There must be 3 unmatched cards to check the set rule.")
        }
    }
    
    private func createNewDeckOfCard () {
        // Add 81 cards in the deck
        for number in Card.Number.all {
            for symbol in Card.Symbol.all {
                for shading in Card.Shading.all {
                    for color in Card.Color.all {
                        cards.append(Card(number: number, symbol: symbol, shading: shading, color: color))
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
