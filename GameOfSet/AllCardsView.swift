//
//  AllCardsView.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 12/6/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import UIKit

class AllCardsView: UIView {
    private var cardViews = [CardView]()
    private lazy var testCardView = createCard()
    
    private func createCard() -> CardView {
        let cardView = CardView()
        addSubview(cardView)
        return cardView
    }
    
    private func configureCardView(_ view: UIView) {
        view.frame.size = CGSize.init(width: 100.0, height: 200.0)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCardView(testCardView)
        testCardView.frame.origin = bounds.origin
    }
}
