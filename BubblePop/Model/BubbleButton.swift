//
//  BubbleButton.swift
//  BubblePop
//
//  Created by zohvin basnyat on 5/11/20.
//  Copyright © 2020 zohvin. All rights reserved.
//

import UIKit

class BubbleButton: UIButton{
    
//    var isManuallyDestroyed = false
    var value: Int = 0
    var radius: UInt32{
        return UInt32(UIScreen.main.bounds.width/14)
    }
    
    // required method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // inherited methods
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        // make Button Round
        self.layer.cornerRadius = CGFloat(radius)
        
        // button color with value provided as per chance
        let possibility = Int(arc4random_uniform(100))
        switch possibility {
        case 0...39:
            self.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.value = 1
        case 40...69:
            self.backgroundColor = #colorLiteral(red: 0.8867238626, green: 0.290980173, blue: 0.9032632292, alpha: 1)
            self.value = 2
        case 70...84:
            self.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self.value = 5
        case 85...94:
            self.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            self.value = 8
        case 95...99:
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.value = 10
        default:
            print("error")
        }
    }
    
    func animateBoing(){
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.5
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.9
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        layer.add(springAnimation, forKey: nil)
        
    }
    
    
    // use these commented animation if later want to change the animation 
//    func animateShrink(){
//        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
//        springAnimation.duration = 0.4
//        springAnimation.fromValue = 1
//        springAnimation.toValue = 0
//        springAnimation.repeatCount = 1
//        springAnimation.initialVelocity = 0.5
//        springAnimation.damping = 1
//        layer.add(springAnimation, forKey: nil)
//
//    }
    
//    func animateOpacity() {
//        let springAnimationOpacity = CASpringAnimation(keyPath: "opacity")
//        springAnimationOpacity.duration = 0.8
//        springAnimationOpacity.fromValue = 0
//        springAnimationOpacity.toValue = 1
//        springAnimationOpacity.repeatCount = 1
//        springAnimationOpacity.initialVelocity = 0.3
//        layer.add(springAnimationOpacity, forKey: nil)
//    }
    
//    func animateCreate(){
//        let springAnimationDestroy = CASpringAnimation(keyPath: "transform.scale")
//        springAnimationDestroy.duration = 0.5
//        springAnimationDestroy.fromValue = 1
//        springAnimationDestroy.toValue = 2
//        springAnimationDestroy.repeatCount = 1
//        springAnimationDestroy.initialVelocity = 0.9
//        springAnimationDestroy.damping = 1
//        layer.add(springAnimationDestroy, forKey: nil)
//    }
    
    func animateRemove(){
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.alpha = 0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
        
    }
}
