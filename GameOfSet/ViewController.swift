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
    @IBAction func swipeThreeMoreCard(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            dealThreeCards()
        default: break
        }
    }
    @IBAction func shuffleCards(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            setGame.shuffleCurrentlyDisplayedCards()
            updateViewFromModel()
        default: break
        }
        
    }
    @IBAction func dealThreeMoreCard(_ sender: UIButton) {
        dealThreeCards()
    }
    @IBOutlet weak var dealThreeMoreCardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame.dealCard(total: 12)
        updateViewFromModel()
    }
    
    private func dealThreeCards() {
        let _ = setGame.checkExistingSet(sender: Constants.dealThreeMoreCardsActionTag)
        setGame.existingSetsOnScreen = []
        setGame.dealCard(total: setGame.cards.count < 3 ? setGame.cards.count : 3, sender: Constants.dealThreeMoreCardsActionTag)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        // TODO: Make cards drawn nicely on landscape mode as well
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

extension ViewController {
    private struct Constants {
        static let dealThreeMoreCardsActionTag = 200
        static let cheatActionTag = 100
    }
}

