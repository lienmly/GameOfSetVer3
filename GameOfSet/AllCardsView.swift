//
//  AllCardsView.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 12/6/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import UIKit

class AllCardsView: UIView {
    var setGame = SetGame() { didSet { setNeedsLayout(); setNeedsDisplay() }}
    private lazy var grid = Grid(layout: .aspectRatio(CGFloat(Constants.cardWidthToHeight)), frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: CGFloat(bounds.size.width), height: CGFloat(bounds.size.height))))
    
    private func createCard(index cardIndex: Int) -> CardView {
        let cardView = CardView()
        cardView.card = setGame.dealCards[cardIndex]
        cardView.setGame = setGame
        let tap = UITapGestureRecognizer(target: cardView, action: #selector(cardView.selected))
        cardView.addGestureRecognizer(tap)

        addSubview(cardView)
        return cardView
    }
    
    private func configureCardView(_ view: UIView, _ frame: CGRect) {
        let delta = frame.width*Constants.cardEdgeWidthToCellFrameSize
        let insetFrame = frame.insetBy(dx: delta, dy: delta)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.7, delay: 0.0, options: .layoutSubviews, animations: {view.frame = insetFrame}, completion: nil)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Recalculate grid based on device's orientation
        grid = Grid(layout: .aspectRatio(CGFloat(Constants.cardWidthToHeight)), frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: CGFloat(bounds.size.width), height: CGFloat(bounds.size.height))))
        grid.cellCount = self.setGame.dealCards.count
        
        // Empty all subviews
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        // Add subviews
        for cellIndex in 0..<grid.cellCount {
            let card = createCard(index: cellIndex)
            configureCardView(card, grid[cellIndex]!)
            card.frame.origin = grid[cellIndex]!.origin
        }
        
        self.setGame.removeMatchedCards()
    }
}

extension AllCardsView {
    private struct Constants {
        static let cardWidthToHeight: CGFloat = 0.7
        static let cardEdgeWidthToCellFrameSize: CGFloat = 0.02
    }
}
