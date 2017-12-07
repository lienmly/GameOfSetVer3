//
//  AllCardsView.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 12/6/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import UIKit

class AllCardsView: UIView {
    var cardCount: Int = 27 { didSet {  setNeedsLayout() } }
    var cardViewsProperties = [(Card.Number, Card.Symbol, Card.Shading, Card.Color, Card.State, Int)]() // (_,_,_,_,_,uniqueID)
    private lazy var grid = Grid(layout: .aspectRatio(CGFloat(Constants.cardWidthToHeight)), frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: CGFloat(bounds.size.width), height: CGFloat(bounds.size.height))))
    
    private func createCard(index cardIndex: Int) -> CardView {
        let cardView = CardView()
        cardView.number = cardViewsProperties[cardIndex].0
        cardView.symbol = cardViewsProperties[cardIndex].1
        cardView.shading = cardViewsProperties[cardIndex].2
        cardView.color = cardViewsProperties[cardIndex].3
        cardView.state = cardViewsProperties[cardIndex].4
        cardView.uniqueID = cardViewsProperties[cardIndex].5
        addSubview(cardView)
        return cardView
    }
    
    private func configureCardView(_ view: UIView, _ frame: CGRect) {
        let delta = frame.width*Constants.cardEdgeWidthToCellFrameSize
        let insetFrame = frame.insetBy(dx: delta, dy: delta)
        view.frame.size = CGSize.init(width: insetFrame.width, height: insetFrame.height)
        view.frame.origin = insetFrame.origin
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    func set(cardCount numberOfCard: Int) {
        cardCount = numberOfCard
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.cellCount = self.cardCount
        
        // Empty all subviews
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        // Add subviews
        for cellIndex in 0..<grid.cellCount {
            let card = createCard(index: cellIndex)
            configureCardView(card, grid[cellIndex]!)
            card.frame.origin = grid[cellIndex]!.origin
        }
    }
}

extension AllCardsView {
    private struct Constants {
        static let cardWidthToHeight: CGFloat = 0.7
        static let cardEdgeWidthToCellFrameSize: CGFloat = 0.02
    }
}
