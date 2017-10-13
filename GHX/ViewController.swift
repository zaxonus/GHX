//
//  ViewController.swift
//  GHX
//
//  Created by Michel Bouchet on 2017/10/11.
//  Copyright © 2017 Michel Bouchet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var signature:SignatureView!, signatureConstraints,labelsToSignConstraints:[NSLayoutConstraint]!,
    topLabel,bottomLabel:UILabel!, gameRandomValue,numberOfPlayers:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        //numberOfPlayers = 105
        numberOfPlayers = 30

        tapHandler()
        
        setLabelsWithLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    func labelsSignConstraints() -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: topLabel,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: signature,
                                   attribute: .top,
                                   multiplier: 1.0, constant: -17.0),
                NSLayoutConstraint(item: bottomLabel,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: signature,
                                   attribute: .bottom,
                                   multiplier: 1.0, constant: 17.0)]
    }
    
    
    func setLabelsWithLayout() {
        topLabel = UILabel(); bottomLabel = UILabel()
        
        for label in [topLabel,bottomLabel] {
            label?.backgroundColor = UIColor.black.withAlphaComponent(0.19)
            label?.layer.cornerRadius = 13.0
            label?.clipsToBounds = true
            label?.textAlignment = .center
            label?.textColor = UIColor.white
            label?.numberOfLines = 0
            label?.adjustsFontSizeToFitWidth = true
            label?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label!)
            view.addConstraints([
                NSLayoutConstraint(item: label!,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .centerX,
                                   multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: label!,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .width,
                                   multiplier: 0.7, constant: 0.0),
                NSLayoutConstraint(item: label!,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 0.0, constant: 90.0)])
        }
        
        labelsToSignConstraints = labelsSignConstraints()
        view.addConstraints(labelsToSignConstraints)
    }
    
    
    func getSignatureConstraints() -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: signature,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .centerX,
                                   multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: signature,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .centerY,
                                   multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: signature,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: view,
                                   attribute: .width,
                                   multiplier: 0.7, constant: 0.0),
                NSLayoutConstraint(item: signature,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: signature,
                                   attribute: .width,
                                   multiplier: 1.0, constant: 0.0)]
    }
    
    func randomBorder(_ number: Int? = nil) -> UIColor {
        let randomValue = (number == nil) ? arc4random_uniform(3) : UInt32(number!)
        switch randomValue {
        case 0:
            return UIColor.black
        case 1:
            return UIColor.darkGray
        case 2:
            return UIColor.white
        default: // This will never happen
            return UIColor.clear
        }
    }
    
    
    func randomColor(_ number: Int? = nil) -> UIColor {
        let randomValue = (number == nil) ? arc4random_uniform(7) : UInt32(number!)
        switch randomValue {
        case 0:
            return UIColor.red
        case 1:
            return UIColor.green
        case 2:
            return UIColor.blue
        case 3:
            return UIColor.yellow
        case 4:
            return UIColor.cyan
        case 5:
            return UIColor.magenta
        case 6:
            return UIColor.orange
        default: // This will never happen
            return UIColor.clear
        }
    }
    
    
    func setTheTextContents() {
        switch gameRandomValue {
            //        case 0:
            //            topLabel.text = ""
        //            bottomLabel.text = ""
        case 0:
            topLabel.text = "Michel wins!"
            bottomLabel.text = "To be or not to be\nThat is the question."
        case 1:
            topLabel.text = "John wins!"
            bottomLabel.text = "A bird in the hand is\nworth two in the bush."
        default:
            topLabel.text = "Nobody wins!"
            bottomLabel.text = "That is too bad!"
        }
    }
    
    
    func setTextOnLabels() {
        setTheTextContents()
        
        let labelFont = UIFont.preferredFont(forTextStyle: .title1)
        topLabel.font = labelFont
        bottomLabel.font = labelFont

        var referSize,actualSize:CGSize
        let options : NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        for label in [topLabel,bottomLabel] {
            referSize = CGSize(width: (label?.frame.size.width)!,
                               height: UIScreen.main.bounds.size.height)
            repeat {
                actualSize = (label?.text!.boundingRect(with: referSize, options: options,
                                                        attributes: [NSAttributedStringKey.font: (label?.font)!],
                                                        context: nil).size)!
                if actualSize.height <= (label?.frame.size.height)! {break} // All is fine.
                if (label?.font.pointSize)! < CGFloat(15.0) {break} // We give up.
                label?.font = label?.font.withSize((label?.font.pointSize)! - 0.5)
            } while true
        }
    }
    
    
    @objc func tapHandler() {
        if signature != nil {
            view.removeConstraints(labelsToSignConstraints)
            view.removeConstraints(signatureConstraints)
            signature.removeFromSuperview()
            labelsToSignConstraints.removeAll(keepingCapacity: true)
            signatureConstraints.removeAll(keepingCapacity: true)
        }
        
        gameRandomValue = Int(arc4random_uniform(UInt32(numberOfPlayers)))
        
        let randomMod2,randomMod3,randomMod5,randomMod7:Int
        
        if (numberOfPlayers % 2 == 0) {randomMod2 = gameRandomValue % 2}
        else {randomMod2 = 0}
        if (numberOfPlayers % 3 == 0) {randomMod3 = gameRandomValue % 3}
        else {randomMod3 = 0}
        if (numberOfPlayers % 5 == 0) {randomMod5 = gameRandomValue % 5}
        else {randomMod5 = 0}
        if (numberOfPlayers % 7 == 0) {randomMod7 = gameRandomValue % 7}
        else {randomMod7 = 0}

        signature = SignatureView(frame: CGRect.zero,
                                  color: randomColor(randomMod7),
                                  border: randomBorder(randomMod3),
                                  shape: randomMod5,
                                  goldMark: (randomMod2==1))
        signature.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signature)
        signatureConstraints = getSignatureConstraints()
        view.addConstraints(signatureConstraints)
        
        if topLabel != nil {
            labelsToSignConstraints = labelsSignConstraints()
            view.addConstraints(labelsToSignConstraints)
            setTextOnLabels()
        }
    }
}
