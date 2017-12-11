//
//  ViewController.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 11/29/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var setGame = SetGame()
    lazy var allAvailableCardPosition = Array(0..<cardButtons.count)
    let colorPair = [Card.Color.one:#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), .two:#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), .three:#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
    let symbolPair = [Card.Symbol.one:"▲", .two:"●", .three:"■"]
    var cardPosition = [Int:Int]() // [cardButtonIndex:cardUniqueID]
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var allCardsView: AllCardsView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBAction func cheat(_ sender: UIButton) {
        setGame.score -= 2
        if setGame.checkExistingSet() {
            let cardSet = setGame.existingSetsOnScreen[0]
            UIView.animate(withDuration: 1.0, animations: {
                for buttonIndex in self.cardButtons.indices {
                    if buttonIndex == cardSet.0.positionOnScreen {
                        self.cardButtons[buttonIndex].backgroundColor = #colorLiteral(red: 0.6397396763, green: 0.9946970633, blue: 1, alpha: 1)
                    }
                    if buttonIndex == cardSet.1.positionOnScreen {
                        self.cardButtons[buttonIndex].backgroundColor = #colorLiteral(red: 0.6397396763, green: 0.9946970633, blue: 1, alpha: 1)
                    }
                    if buttonIndex == cardSet.2.positionOnScreen {
                        self.cardButtons[buttonIndex].backgroundColor = #colorLiteral(red: 0.6397396763, green: 0.9946970633, blue: 1, alpha: 1)
                    }
                }
            }, completion: nil)
        }
        setGame.existingSetsOnScreen = []
    }
    @IBAction func resetGame(_ sender: UIButton) {
        setGame.refreshGame()
        // Refresh ViewController variables
        allAvailableCardPosition = Array(0..<cardButtons.count)
        cardPosition = [:]
        // Update View
        updateViewFromModel()
    }
    @IBAction func touchCard(_ sender: UIButton) {
        if let buttonIndex = cardButtons.index(of: sender), let cardID = cardPosition[buttonIndex] {
            setGame.selectCard(id: cardID)
            updateViewFromModel()
        } else {
            print("(1)This button is not in cardButtons or (2)No card at this button")
        }
    }
    @IBAction func dealThreeMoreCard(_ sender: UIButton) {
//        setGame.score -= 1
//        if setGame.checkExistingSet() {
//            setGame.score -= 4
//        }
        setGame.dealCard(total: setGame.cards.count < 3 ? setGame.cards.count : 3)
        updateViewFromModel()
    }
    @IBOutlet weak var dealThreeMoreCardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Deal 12 cards at game start
        setGame.dealCard(total: 12)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        // Display deal cards
        allCardsView.setGame = setGame
//        allCardsView.cardViewsProperties = []
//        for cardIndex in 0..<setGame.dealCards.count {
//            let number = setGame.dealCards[cardIndex].number
//            let symbol = setGame.dealCards[cardIndex].symbol
//            let shading = setGame.dealCards[cardIndex].shading
//            let color = setGame.dealCards[cardIndex].color
//            let id = setGame.dealCards[cardIndex].uniqueID
//            let state = setGame.dealCards[cardIndex].state
//            allCardsView.cardViewsProperties.append((number, symbol, shading, color, state, id))
//        }
//        if setGame.currentDealCardNumber > 0 {
//            // -- Make card visible on selected random positions
//            for dealCardIndex in 0..<setGame.currentDealCardNumber {
//                var position = 0
//                if setGame.threePositionsOfRecentlyMatchedCards.count > 0 {
//                    position = setGame.threePositionsOfRecentlyMatchedCards.remove(at: 0)
//                } else {
//                    let randomCardButtonIndex = allAvailableCardPosition.remove(at: Int(arc4random_uniform(UInt32(allAvailableCardPosition.count))))
//                    position = randomCardButtonIndex
//                }
//                setGame.dealCards[setGame.dealCards.count - dealCardIndex - 1].positionOnScreen = position
//                drawCard(on: cardButtons[position], dealCardIndex: setGame.dealCards.count - dealCardIndex - 1)
//            }
//            setGame.threePositionsOfRecentlyMatchedCards = []
//            // -- Make card invisible on the rest of cardButtons positions
//            for positionIndex in allAvailableCardPosition {
//                cardButtons[positionIndex].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//                cardButtons[positionIndex].layer.borderWidth = 0.0
//                cardButtons[positionIndex].setTitle("", for: .normal)
//                cardButtons[positionIndex].setAttributedTitle(NSAttributedString(string: ""), for: .normal)
//                cardButtons[positionIndex].isEnabled = false
//            }
//            setGame.currentDealCardNumber = 0
//        }
        
        
        
        // Select & Deselect cards
//        for cardButtonIndex in cardButtons.indices {
//            if let cardID = cardPosition[cardButtonIndex] {
//                cardButtons[cardButtonIndex].layer.borderWidth = 0.0
//                cardButtons[cardButtonIndex].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                if setGame.selectedCards[cardID] != nil {
//                    if setGame.selectedCards[cardID] == .undecided { // deciding
//                        cardButtons[cardButtonIndex].layer.borderWidth = 5.0
//                        cardButtons[cardButtonIndex].layer.borderColor = UIColor.green.cgColor
//                    } else if setGame.selectedCards[cardID] == .matched { // already matched
//                        cardButtons[cardButtonIndex].layer.borderWidth = 0.0
//                        cardButtons[cardButtonIndex].backgroundColor = UIColor.yellow
//                        cardButtons[cardButtonIndex].isEnabled = false
//                    } else { // not matched
//                        cardButtons[cardButtonIndex].layer.borderWidth = 5.0
//                        cardButtons[cardButtonIndex].layer.borderColor = UIColor.red.cgColor
//                    }
//                } else { // Remove all special effects
//                    cardButtons[cardButtonIndex].layer.borderWidth = 0.0
//                    cardButtons[cardButtonIndex].backgroundColor = UIColor.white
//                    if cardButtons[cardButtonIndex].isEnabled == false {
//                        // If cards in deck == 0 => hide all matched cards
//                        cardButtons[cardButtonIndex].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//                        cardButtons[cardButtonIndex].setAttributedTitle(NSAttributedString(string: ""), for: .normal)
//                        cardButtons[cardButtonIndex].setTitle("", for: .normal)
//                    }
//                }
//            }
//        }
        // Disable "Deal 3 cards"
        if setGame.cards.count == 0 {
            dealThreeMoreCardButton.isEnabled = false
        }
        // Set score label
        scoreLabel.text = "Score: \(setGame.score)"
    }
    
    private func drawCard(on cardToDrawOn: UIButton, dealCardIndex associatedDealCardIndex: Int) {
        cardPosition[cardButtons.index(of: cardToDrawOn)!] = setGame.dealCards[associatedDealCardIndex].uniqueID
        let shadingOnCard = setGame.dealCards[associatedDealCardIndex].shading
        let titleColor = colorPair[setGame.dealCards[associatedDealCardIndex].color]!
        let titleContent = symbolPair[setGame.dealCards[associatedDealCardIndex].symbol]!.multiply(by: setGame.dealCards[associatedDealCardIndex].number.rawValue)
        cardToDrawOn.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        cardToDrawOn.isEnabled = true
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor : titleColor.withAlphaComponent(shadingOnCard == .two ? CGFloat(0.40) : CGFloat(1)),
            .strokeWidth : shadingOnCard == .three ? 15 : -1
        ]
        
        let attribtext = NSAttributedString(string: titleContent, attributes: attributes)
        cardToDrawOn.setAttributedTitle(attribtext, for: .normal)
    }
}

