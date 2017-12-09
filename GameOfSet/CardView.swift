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
    let colorMatching = [Card.Color.one: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), .two: #colorLiteral(red: 0.5680870746, green: 0.268135684, blue: 0.7625713832, alpha: 1), .three: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
    
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
        let insetFrame = bounds.insetBy(dx: symbolGapToCardEdge, dy: symbolGapToCardEdge)
        let singleSymbolFrame = insetFrame.insetBy(dx: 0, dy: insetFrame.height/2.9)
        drawSymbol(singleSymbolFrame: singleSymbolFrame)
    }
    
    private func drawSymbol(singleSymbolFrame: CGRect) {
        var path = UIBezierPath()
        var symbolFrame = singleSymbolFrame
        let symbolGap = symbolFrame.height*Constants.symbolGapHeightToSymbolFrameHeight
        
        switch number {
        case .two: symbolFrame = symbolFrame.offsetBy(dx: 0, dy: -symbolFrame.height*Constants.twoSymbolOffsetToSymbolFrameHeight)
        case .three: symbolFrame = symbolFrame.offsetBy(dx: 0, dy: -symbolFrame.height-symbolGap)
        default: break
        }
        
        for _ in 0...number.rawValue {
            switch symbol {
            case .one:
                path = UIBezierPath(roundedRect: symbolFrame, cornerRadius: symbolFrame.height*Constants.symbolCornerRadiusToBoundsHeight)
                drawSymbolShading(for: path, with: colorMatching[color]!, inside: symbolFrame)
            case .two:
                path.move(to: CGPoint(x: symbolFrame.minX, y: symbolFrame.maxY))
                path.addCurve(to: CGPoint(x: symbolFrame.maxX, y: symbolFrame.minY),
                              controlPoint1: CGPoint(x: symbolFrame.minX , y: symbolFrame.minY - symbolFrame.height*Constants.controlPoint2HeightToSymbolFrameHeight),
                              controlPoint2: CGPoint(x: symbolFrame.maxX - Constants.controlPoint2_xToFrameWidth*symbolFrame.width, y: symbolFrame.maxY))
                path.addCurve(to: CGPoint(x: symbolFrame.minX, y: symbolFrame.maxY),
                              controlPoint1: CGPoint(x: symbolFrame.maxX , y: symbolFrame.maxY + symbolFrame.height*Constants.controlPoint2HeightToSymbolFrameHeight),
                              controlPoint2: CGPoint(x: symbolFrame.minX + Constants.controlPoint2_xToFrameWidth*symbolFrame.width, y: symbolFrame.minY))
                drawSymbolShading(for: path, with: colorMatching[color]!, inside: symbolFrame)
            case .three:
                path.move(to: CGPoint(x: symbolFrame.minX, y: symbolFrame.maxY - symbolFrame.height/2))
                path.addLine(to: CGPoint(x: symbolFrame.maxX - symbolFrame.width/2, y: symbolFrame.minY))
                path.addLine(to: CGPoint(x: symbolFrame.maxX, y: symbolFrame.minY + symbolFrame.height/2))
                path.addLine(to: CGPoint(x: symbolFrame.minX + symbolFrame.width/2, y: symbolFrame.maxY))
                path.close()
                drawSymbolShading(for: path, with: colorMatching[color]!, inside: symbolFrame)
            }
            symbolFrame = symbolFrame.offsetBy(dx: 0, dy: symbolGap + symbolFrame.height)
        }
    }
    
    private func drawSymbolShading(for path: UIBezierPath, with color: UIColor, inside frame: CGRect) {
        switch shading {
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
