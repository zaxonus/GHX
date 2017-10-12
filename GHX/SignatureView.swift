//
//  SignatureView.swift
//  GHX
//
//  Created by Michel Bouchet on 2017/10/11.
//  Copyright © 2017 Michel Bouchet. All rights reserved.
//

import UIKit

class SignatureView: UIView {
    var mainColor,borderColor:UIColor!,
    shapeNumber:Int!
    
    init(frame: CGRect, color: UIColor, border: UIColor, shape: Int) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        mainColor = color
        borderColor = border
        shapeNumber = shape
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext(),
        lineThickness:CGFloat = 13.0,
        sideLength:CGFloat = UIScreen.main.bounds.size.width * 3.0 / 5.0

        func fixPath(color: UIColor, border bdColor: UIColor) {
            context?.closePath()
            context?.setFillColor(color.cgColor)
            context?.setStrokeColor(bdColor.cgColor)
            context?.setLineWidth(lineThickness)
            context?.drawPath(using: .fillStroke)
        }
        
        func paintDisk(color: UIColor, border bdColor: UIColor,
                           withSide side: CGFloat) {
            let varFrame = CGRect(origin: CGPoint(x: (rect.width - side) / 2.0,
                                                  y: (rect.height - side) / 2.0),
                                  size: CGSize(width: side, height: side))
            context?.addEllipse(in: varFrame)
            fixPath(color: color, border: bdColor)
        }

        func paintTriangle(color: UIColor, border bdColor: UIColor,
                        withSide side: CGFloat) {
            context?.move(to: CGPoint(x: (rect.width - side) / 2.0,
                                      y: (rect.height - side) / 2.0))
            context?.addLine(to: CGPoint(x: (rect.width + side) / 2.0,
                                         y: (rect.height - side) / 2.0))
            context?.addLine(to: CGPoint(x: rect.width / 2.0,
                                         y: (rect.height + side * (sqrt(3.0) - 1.0)) / 2.0))
            fixPath(color: color, border: bdColor)
        }

        func paintSuare(color: UIColor, border bdColor: UIColor,
                        withSide side: CGFloat) {
            context?.move(to: CGPoint(x: (rect.width - side) / 2.0,
                                      y: (rect.height - side) / 2.0))
            context?.addLine(to: CGPoint(x: (rect.width + side) / 2.0,
                                         y: (rect.height - side) / 2.0))
            context?.addLine(to: CGPoint(x: (rect.width + side) / 2.0,
                                         y: (rect.height + side) / 2.0))
            context?.addLine(to: CGPoint(x: (rect.width - side) / 2.0,
                                         y: (rect.height + side) / 2.0))
            fixPath(color: color, border: bdColor)
        }

        func paintRegularPolygon(color: UIColor, border bdColor: UIColor,
                                 withRadius radius: CGFloat, andSideNumber number: Int) {
            context?.move(to: CGPoint(x: rect.width / 2.0,
                                      y: rect.height / 2.0 + radius))
            let centerPoint = CGPoint(x: rect.width / 2.0,
                                      y: rect.height / 2.0)
            var xCoord,yCoord,angle: CGFloat
            for i in 1..<number {
                angle = CGFloat.pi / 2.0 + (CGFloat.pi * 2.0 * CGFloat(i)) / CGFloat(number)
                xCoord = centerPoint.x + cos(angle) * radius
                yCoord = centerPoint.y + sin(angle) * radius
                context?.addLine(to: CGPoint(x: xCoord, y: yCoord))
            }
            fixPath(color: color, border: bdColor)
        }
        
        func paintPentagon(color: UIColor, border bdColor: UIColor,
                           withRadius radius: CGFloat) {
            paintRegularPolygon(color: color, border: bdColor,
                                withRadius: radius, andSideNumber: 5)
        }

        func paintHexagon(color: UIColor, border bdColor: UIColor,
                          withRadius radius: CGFloat) {
            paintRegularPolygon(color: color, border: bdColor,
                                withRadius: radius, andSideNumber: 6)
        }
        
        switch shapeNumber {
        case 0:
            paintDisk(color: mainColor, border: borderColor,
                      withSide: sideLength)
        case 1:
            paintTriangle(color: mainColor, border: borderColor,
                          withSide: sideLength)
        case 2:
            paintSuare(color: mainColor, border: borderColor,
                       withSide: sideLength)
        case 3:
            paintPentagon(color: mainColor, border: borderColor,
                          withRadius: sideLength / 2.0)
        case 4:
            paintHexagon(color: mainColor, border: borderColor,
                         withRadius: sideLength / 2.0)
        default:
            break
        }
    }
}
