//
//  CardView.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 12/5/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import UIKit

class CardView: UIView {
    var number: Card.Number = .one { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var symbol: Card.Symbol = .one { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shading: Card.Shading = .one { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var color: Card.Color = .one { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        drawBackground()
        drawContent()
    }
    
    private func drawBackground() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    private func drawContent() {
        drawSymbol()
    }
    
    private func drawSymbol() {
        let oval = UIBezierPath(roundedRect: bounds.offsetBy(dx: bounds.maxX/2, dy: bounds.maxY/2), cornerRadius: 16.0)
        oval.addClip()
        UIColor.green.setFill()
        oval.fill()
    }
}

extension CardView {
    private struct Constants {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    private var cornerRadius: CGFloat  {
        return bounds.size.height * Constants.cornerRadiusToBoundsHeight
    }
}
