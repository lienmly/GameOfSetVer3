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
    let numberOfCardDealAtStart = 12
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func touchCard(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initially deal 12 cards at game start
        setGame.dealCard(total: numberOfCardDealAtStart)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        // Display deal card & hide the rest
        var dealCardButtonIndices = Set<Int>()
        while dealCardButtonIndices.count < numberOfCardDealAtStart {
            let randomCardButtonIndex = Int(arc4random_uniform(UInt32(cardButtons.count)))
            dealCardButtonIndices.insert(randomCardButtonIndex)
        }
        
        var associatedCardIndex = 0
        for cardButtonIndex in cardButtons.indices {
            if dealCardButtonIndices.contains(cardButtonIndex), associatedCardIndex <= numberOfCardDealAtStart {
                // Make card visible
                drawCard(on: cardButtons[cardButtonIndex], dealCardIndex: associatedCardIndex)
                associatedCardIndex += 1
            }
            else {
                // Make card invisible
                cardButtons[cardButtonIndex].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                cardButtons[cardButtonIndex].setTitle("", for: .normal)
            }
        }
    }
    
    private func drawCard(on cardToDrawOn: UIButton, dealCardIndex associatedDealCardIndex: Int) {
        let numberOnCard = setGame.dealCards[associatedDealCardIndex].number
        let symbolOnCard = setGame.dealCards[associatedDealCardIndex].symbol
        let shadingOnCard = setGame.dealCards[associatedDealCardIndex].shading
        let colorOnCard = setGame.dealCards[associatedDealCardIndex].color
        
        cardToDrawOn.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
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
            .strokeWidth : shadingOnCard == .three ? 3 : -1
        ]
        
        let attribtext = NSAttributedString(string: titleContent, attributes: attributes)
        cardToDrawOn.setAttributedTitle(attribtext, for: .normal)
    }
}

