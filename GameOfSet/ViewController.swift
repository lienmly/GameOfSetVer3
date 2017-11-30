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
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func touchCard(_ sender: UIButton) {
        print("Card is touched")
    }
    @IBAction func dealThreeMoreCard(_ sender: UIButton) {
        setGame.dealCard(total: allAvailableCardPosition.count < 3 ? allAvailableCardPosition.count : 3)
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Deal 12 cards at game start
        setGame.dealCard(total: 12)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        // Display deal card & hide the rest
        // -- Make card visible on selected random positions
        for dealCardIndex in 0..<setGame.currentDealCardNumber {
            let randomCardButtonIndex = allAvailableCardPosition.remove(at: Int(arc4random_uniform(UInt32(allAvailableCardPosition.count))))
            drawCard(on: cardButtons[randomCardButtonIndex], dealCardIndex: setGame.dealCards.count - dealCardIndex - 1)
        }
        // -- Make card invisible on the rest of cardButtons positions
        for positionIndex in allAvailableCardPosition {
            cardButtons[positionIndex].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cardButtons[positionIndex].setTitle("", for: .normal)
            cardButtons[positionIndex].isEnabled = false
        }
    }
    
    private func drawCard(on cardToDrawOn: UIButton, dealCardIndex associatedDealCardIndex: Int) {
        let numberOnCard = setGame.dealCards[associatedDealCardIndex].number
        let symbolOnCard = setGame.dealCards[associatedDealCardIndex].symbol
        let shadingOnCard = setGame.dealCards[associatedDealCardIndex].shading
        let colorOnCard = setGame.dealCards[associatedDealCardIndex].color
        
        cardToDrawOn.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        var titleColor: UIColor
        var titleContent: String
        
        switch colorOnCard {
        case .one: titleColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) case .two: titleColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) case .three: titleColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
    
        switch symbolOnCard {
        case .one: titleContent = "▲".multiply(by: numberOnCard.rawValue)
        case .two: titleContent = "●".multiply(by: numberOnCard.rawValue)
        case .three: titleContent = "■".multiply(by: numberOnCard.rawValue)
        }
        
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor : titleColor.withAlphaComponent(shadingOnCard == .two ? CGFloat(0.40) : CGFloat(1)),
            .strokeWidth : shadingOnCard == .three ? 15 : -1
        ]
        
        let attribtext = NSAttributedString(string: titleContent, attributes: attributes)
        cardToDrawOn.setAttributedTitle(attribtext, for: .normal)
    }
}

