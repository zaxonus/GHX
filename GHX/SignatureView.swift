//
//  SignatureView.swift
//  GHX
//
//  Created by Michel Bouchet on 2017/10/11.
//  Copyright © 2017 Michel Bouchet. All rights reserved.
//

import UIKit

let lineThickness:CGFloat = 13.0,
    sideLength:CGFloat = UIScreen.main.bounds.size.width * 3.0 / 5.0

class SignatureView: UIView {
    var mainColor,borderColor:UIColor!,
    shapeNumber:Int!, goldenFlag:Bool!
    
    init(frame: CGRect, color: UIColor, border: UIColor, shape: Int, goldMark: Bool) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        mainColor = color
        borderColor = border
        shapeNumber = shape
        goldenFlag = goldMark
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext(),
        goldColor = UIColor(red: 212.0/255.0,
                            green: 175.0/255.0,
                            blue: 55.0/255.0,
                            alpha: 1.0)

        func fixPath(color: UIColor, border bdColor: UIColor,
                     thickness: CGFloat = lineThickness) {
            context?.closePath()
            context?.setFillColor(color.cgColor)
            context?.setStrokeColor(bdColor.cgColor)
            context?.setLineWidth(thickness)
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
        
        func paintStar(color: UIColor, border bdColor: UIColor,
                                 withRadius radius: CGFloat) {
            let centerPoint:CGPoint
            if shapeNumber != 1 {
                centerPoint = CGPoint(x: rect.width / 2.0,
                                      y: rect.height / 2.0)
            } else {
                centerPoint = CGPoint(x: rect.width / 2.0,
                                      y: rect.height / 2.0 - sideLength / 5.0)
            }
            context?.move(to: CGPoint(x: centerPoint.x,
                                      y: centerPoint.y + radius))
            var xCoord,yCoord,angle: CGFloat
            for i in 1..<10 {
                angle = CGFloat.pi / 2.0 + (CGFloat.pi * 2.0 * CGFloat(i)) / 10
                xCoord = centerPoint.x + cos(angle) * radius * ((i%2==1) ? 0.4:1.0)
                yCoord = centerPoint.y + sin(angle) * radius * ((i%2==1) ? 0.4:1.0)
                context?.addLine(to: CGPoint(x: xCoord, y: yCoord))
            }
            fixPath(color: color, border: bdColor,
                    thickness: lineThickness / 4.0)
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
        
        if goldenFlag {
            paintStar(color: goldColor,
                      border: borderColor, withRadius: sideLength / 6.0)
        }
    }
}
