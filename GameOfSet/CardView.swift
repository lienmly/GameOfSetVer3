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
    var state: Card.State = .unselected { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var uniqueID: Int = 0 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        drawBackground()
        drawContent()
    }
    
    private func drawBackground() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    private func drawContent() {
        drawSymbol()
    }
    
    private func drawSymbol() {
        let insetFrame = bounds.insetBy(dx: symbolGapToCardEdge, dy: symbolGapToCardEdge)
        switch symbol {
        case .one:
            let oval = UIBezierPath(roundedRect: insetFrame.insetBy(dx: 0, dy: insetFrame.height/3), cornerRadius: insetFrame.height*Constants.cornerRadiusToBoundsHeight)
            oval.addClip()
            UIColor(red: 37/255, green: 130/255, blue: 28/255, alpha: 1).setFill()
            oval.fill()
        case .two: break
        case .three: break
        default: break
        }
        
    }
}

extension CardView {
    private struct Constants {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cardFrameInsetToBound: CGFloat = 0.07
    }
    private var cornerRadius: CGFloat  {
        return bounds.size.height * Constants.cornerRadiusToBoundsHeight
    }
    private var symbolGapToCardEdge: CGFloat {
        return bounds.size.width * Constants.cardFrameInsetToBound
    }
}
