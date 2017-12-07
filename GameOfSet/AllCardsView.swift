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
    private lazy var testCardView = createCard()
    private lazy var grid = Grid(layout: .aspectRatio(CGFloat(Constants.cardWidthToHeight)), frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: CGFloat(bounds.size.width), height: CGFloat(bounds.size.height))))
    
    private func createCard() -> CardView {
        let cardView = CardView()
        addSubview(cardView)
        return cardView
    }
    
    private func configureCardView(_ view: UIView, _ frame: CGRect) {
        let deltaX = frame.width*Constants.cardEdgeWidthToCellFrameSize
        let deltaY = frame.height*Constants.cardEdgeWidthToCellFrameSize
        let insetFrame = frame.insetBy(dx: deltaX, dy: deltaY)
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
            let card = createCard()
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
