//
//  AllCardsView.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 12/6/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import UIKit

@IBDesignable
class AllCardsView: UIView {
    private var cardViews = [CardView]()
    private lazy var testCardView = createCard()
    private lazy var grid = Grid(layout: .aspectRatio(CGFloat(Constants.cardWidthToHeight)), frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: CGFloat(bounds.size.width), height: CGFloat(bounds.size.height))))
    
    private func createCard() -> CardView {
        let cardView = CardView()
        addSubview(cardView)
        return cardView
    }
    
    private func configureCardView(_ view: UIView) {
        view.frame.size = CGSize.init(width: grid.cellSize.width, height: grid.cellSize.height)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.cellCount = 81
        
        for cellIndex in 0..<grid.cellCount {
            let card = createCard()
            cardViews.append(card)
            configureCardView(card)
            card.frame.origin = grid[cellIndex]!.origin
        }
        
    }
}

extension AllCardsView {
    private struct Constants {
        static let cardWidthToHeight: CGFloat = 0.7
    }
}
