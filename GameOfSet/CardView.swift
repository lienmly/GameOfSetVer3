//
//  CardView.swift
//  GameOfSet
//
//  Created by Ly, Lien (US - Denver) on 12/5/17.
//  Copyright © 2017 Ly, Lien (US - Denver). All rights reserved.
//

import UIKit

class CardView: UIView {
    var card = Card() { didSet {  setNeedsLayout(); setNeedsDisplay() } }
    var setGame = SetGame() { didSet {  setNeedsLayout(); setNeedsDisplay() } }
    let colorMatching = [Card.Color.one: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), .two: #colorLiteral(red: 0.5680870746, green: 0.268135684, blue: 0.7625713832, alpha: 1), .three: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]

    override func draw(_ rect: CGRect) {
        drawBackground()
        drawContent()
    }
    
    @objc func selected(byHandlingGestureRecognizedBy recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            setGame.selectCardVer2(id: card.uniqueID)

            // Update all cards
            if let allCardsView = self.superview {
                for eachCard in allCardsView.subviews {
                    if let cardView = eachCard as? CardView {
                        cardView.card = setGame.dealCards[setGame.dealCards.index(where: {$0.uniqueID == cardView.card.uniqueID})!]
                    }
                }
            }
        default: break
        }
    }
    
    private func drawBackground() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        
        // TODO: Factor this, too many repeats
        switch card.state {
        case .unselected:
            UIColor.white.setFill()
            roundedRect.fill()
        case .undecided:
            UIColor.white.setFill()
            roundedRect.fill()
            UIColor.green.setStroke()
            roundedRect.lineWidth = bounds.height*Constants.strokeWidthToSymbolFrameHeight
            roundedRect.stroke()
        case .notMatched:
            UIColor.white.setFill()
            roundedRect.fill()
            UIColor.red.setStroke()
            roundedRect.lineWidth = bounds.height*Constants.strokeWidthToSymbolFrameHeight
            roundedRect.stroke()
        case .matched:
            UIColor.yellow.setFill()
            roundedRect.fill()
        default: break
        }
        
    }
    
    private func drawContent() {
        let insetFrame = bounds.insetBy(dx: symbolGapToCardEdge, dy: symbolGapToCardEdge)
        let singleSymbolFrame = insetFrame.insetBy(dx: 0, dy: insetFrame.height/2.9)
        drawSymbol(singleSymbolFrame: singleSymbolFrame)
    }
    
    private func drawSymbol(singleSymbolFrame: CGRect) {
        var path = UIBezierPath()
        var symbolFrame = singleSymbolFrame
        let symbolGap = symbolFrame.height*Constants.symbolGapHeightToSymbolFrameHeight
        
        switch card.number {
        case .two: symbolFrame = symbolFrame.offsetBy(dx: 0, dy: -symbolFrame.height*Constants.twoSymbolOffsetToSymbolFrameHeight)
        case .three: symbolFrame = symbolFrame.offsetBy(dx: 0, dy: -symbolFrame.height-symbolGap)
        default: break
        }
        
        for _ in 0...card.number.rawValue {
            switch card.symbol {
            case .one:
                path = UIBezierPath(roundedRect: symbolFrame, cornerRadius: symbolFrame.height*Constants.symbolCornerRadiusToBoundsHeight)
                drawSymbolShading(for: path, with: colorMatching[card.color]!, inside: symbolFrame)
            case .two:
                path.move(to: CGPoint(x: symbolFrame.minX, y: symbolFrame.maxY))
                path.addCurve(to: CGPoint(x: symbolFrame.maxX, y: symbolFrame.minY),
                              controlPoint1: CGPoint(x: symbolFrame.minX , y: symbolFrame.minY - symbolFrame.height*Constants.controlPoint2HeightToSymbolFrameHeight),
                              controlPoint2: CGPoint(x: symbolFrame.maxX - Constants.controlPoint2_xToFrameWidth*symbolFrame.width, y: symbolFrame.maxY))
                path.addCurve(to: CGPoint(x: symbolFrame.minX, y: symbolFrame.maxY),
                              controlPoint1: CGPoint(x: symbolFrame.maxX , y: symbolFrame.maxY + symbolFrame.height*Constants.controlPoint2HeightToSymbolFrameHeight),
                              controlPoint2: CGPoint(x: symbolFrame.minX + Constants.controlPoint2_xToFrameWidth*symbolFrame.width, y: symbolFrame.minY))
                drawSymbolShading(for: path, with: colorMatching[card.color]!, inside: symbolFrame)
            case .three:
                path.move(to: CGPoint(x: symbolFrame.minX, y: symbolFrame.maxY - symbolFrame.height/2))
                path.addLine(to: CGPoint(x: symbolFrame.maxX - symbolFrame.width/2, y: symbolFrame.minY))
                path.addLine(to: CGPoint(x: symbolFrame.maxX, y: symbolFrame.minY + symbolFrame.height/2))
                path.addLine(to: CGPoint(x: symbolFrame.minX + symbolFrame.width/2, y: symbolFrame.maxY))
                path.close()
                drawSymbolShading(for: path, with: colorMatching[card.color]!, inside: symbolFrame)
            }
            symbolFrame = symbolFrame.offsetBy(dx: 0, dy: symbolGap + symbolFrame.height)
        }
    }
    
    private func drawSymbolShading(for path: UIBezierPath, with color: UIColor, inside frame: CGRect) {
        switch card.shading {
        case .one:
            color.setFill()
            path.fill()
        case .two:
            path.lineWidth = frame.height*Constants.strokeWidthToSymbolFrameHeight
            color.setStroke()
            path.stroke()
        case .three:
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            path.addClip()
            var xPoint = frame.minX + Constants.stripeGapToSymbolFrameWidth*frame.width
            while xPoint < frame.maxX {
                let line = UIBezierPath()
                line.move(to: CGPoint(x: xPoint, y: frame.minY))
                line.addLine(to: CGPoint(x: xPoint, y: frame.maxY))
                line.lineWidth = frame.height*Constants.strokeWidthToSymbolFrameHeight
                color.setStroke()
                line.stroke()
                xPoint = xPoint + Constants.stripeGapToSymbolFrameWidth*frame.width
            }
            context?.restoreGState()
            color.setStroke()
            path.lineWidth = frame.height*Constants.strokeWidthToSymbolFrameHeight
            path.stroke()
        }
    }
}

// TODO: Find all the constants usage throughout, and factor them into class instance variable
extension CardView {
    private struct Constants {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let symbolCornerRadiusToBoundsHeight: CGFloat = 0.4
        static let cardFrameInsetToBound: CGFloat = 0.07
        static let controlPoint2_xToFrameWidth: CGFloat = 0.25
        static let controlPoint2HeightToSymbolFrameHeight: CGFloat = 1.11
        static let symbolGapHeightToSymbolFrameHeight: CGFloat = 0.11
        static let twoSymbolOffsetToSymbolFrameHeight: CGFloat = 0.56
        static let strokeWidthToSymbolFrameHeight: CGFloat = 0.12
        static let stripeGapToSymbolFrameWidth: CGFloat = 0.17
    }
    private var cornerRadius: CGFloat  {
        return bounds.size.height * Constants.cornerRadiusToBoundsHeight
    }
    private var symbolGapToCardEdge: CGFloat {
        return bounds.size.width * Constants.cardFrameInsetToBound
    }
}
