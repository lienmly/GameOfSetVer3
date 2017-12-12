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
    @IBOutlet weak var allCardsView: AllCardsView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBAction func cheat(_ sender: UIButton) {
        setGame.score -= 2
//        if setGame.checkExistingSet() {
//            let cardSet = setGame.existingSetsOnScreen[0]
//            UIView.animate(withDuration: 1.0, animations: {
//                for buttonIndex in self.cardButtons.indices {
//                    if buttonIndex == cardSet.0.positionOnScreen {
//                        self.cardButtons[buttonIndex].backgroundColor = #colorLiteral(red: 0.6397396763, green: 0.9946970633, blue: 1, alpha: 1)
//                    }
//                    if buttonIndex == cardSet.1.positionOnScreen {
//                        self.cardButtons[buttonIndex].backgroundColor = #colorLiteral(red: 0.6397396763, green: 0.9946970633, blue: 1, alpha: 1)
//                    }
//                    if buttonIndex == cardSet.2.positionOnScreen {
//                        self.cardButtons[buttonIndex].backgroundColor = #colorLiteral(red: 0.6397396763, green: 0.9946970633, blue: 1, alpha: 1)
//                    }
//                }
//            }, completion: nil)
//        }
        setGame.existingSetsOnScreen = []
    }
    @IBAction func resetGame(_ sender: UIButton) {
        setGame.refreshGame()
        updateViewFromModel()
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

        // Disable "Deal 3 cards"
        if setGame.cards.count == 0 {
            dealThreeMoreCardButton.isEnabled = false
        }
        // Set score label
        scoreLabel.text = "Score: \(setGame.score)"
    }
}

