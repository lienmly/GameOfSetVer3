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
        setGame.existingSetsOnScreen = []
        if setGame.checkExistingSet(sender: sender.tag) {
            updateViewFromModel()
        }
    }
    @IBAction func resetGame(_ sender: UIButton) {
        setGame.refreshGame()
        updateViewFromModel()
    }
    @IBAction func dealThreeMoreCard(_ sender: UIButton) {
        let _ = setGame.checkExistingSet(sender: sender.tag)
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

