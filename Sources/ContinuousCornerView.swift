//
//  ContinuousCornerView.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2018. 03. 24..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

open class ContinuousCornerView: UIView {

    open override var bounds: CGRect {
        didSet {
            self.setNeedsRedraw()
        }
    }

    open var radius: CGFloat = 16 {
        didSet {
            self.setNeedsRedraw()
        }
    }

    open var offset: CGFloat = 2.42 {
        didSet {
            self.setNeedsRedraw()
        }
    }

    open var fillColor: UIColor = .white {
        didSet {
            self.setNeedsRedraw()
        }
    }

    private func setNeedsRedraw() {
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        let radius = self.radius
        let offset = self.offset * radius
        let rect = self.bounds

        let path = UIBezierPath()
        var point: CGPoint!
        path.move(to: CGPoint(x: rect.minX + offset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - offset, y: rect.minY))
        point = CGPoint(x: rect.maxX, y: rect.minY)
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + offset), controlPoint: point)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - offset))
        point = CGPoint(x: rect.maxX, y: rect.maxY)
        path.addQuadCurve(to: CGPoint(x: rect.maxX - offset, y: rect.maxY), controlPoint: point)
        path.addLine(to: CGPoint(x: rect.minX + offset, y: rect.maxY))
        point = CGPoint(x: rect.minX, y: rect.maxY)
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - offset), controlPoint: point)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + offset))
        point = CGPoint(x: rect.minX, y: rect.minY)
        path.addQuadCurve(to: CGPoint(x: rect.minX + offset, y: rect.minY), controlPoint: point)

        self.fillColor.set()
        path.fill()
    }
}
