//
//  FallingEmojiView.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

extension UIApplication {
    static func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
    }
}

class FallingEmojiView {
    static let shared: FallingEmojiView = FallingEmojiView()
    
    var animators: [UIDynamicAnimator]!
    var isAnimating: Bool = false
    
    func show(emoji: String) {
        animators = []
        guard let window = UIApplication.keyWindow() else { return }
        guard !isAnimating else { return }
        
        isAnimating = true
        
        let parentView = UIView()
        parentView.isUserInteractionEnabled = false
        parentView.frame = window.bounds
        window.addSubview(parentView)
        
        for _ in 0...25 {
            let animator = UIDynamicAnimator()
            let label = UILabel()
            label.text = emoji
            label.isUserInteractionEnabled = false
            label.font = UIFont.systemFont(ofSize: CGFloat.random(in: 10...72))
            label.frame = CGRect(x: CGFloat.random(in: 0..<parentView.frame.width), y: -72, width: 120, height: 48)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0..<3)) {
                parentView.addSubview(label)
                let gravity = UIGravityBehavior(items: [label])
                animator.addBehavior(gravity)
                self.animators.append(animator)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            parentView.removeFromSuperview()
            self.animators.forEach({ $0.removeAllBehaviors() })
            self.isAnimating = false
        }
    }
    
    func showText(text: String) {
        guard let window = UIApplication.keyWindow() else { return }
        guard !isAnimating else { return }
        
        animators = []
        
        isAnimating = true
        
        let parentView = UIView()
        parentView.isUserInteractionEnabled = false
        parentView.frame = window.bounds
        window.addSubview(parentView)
        
        for _ in 0...25 {
            let label = UILabel()
            label.text = text
            label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
            label.backgroundColor = .white
            label.layer.cornerRadius = 8.0
            label.lineBreakMode = .byWordWrapping
            label.clipsToBounds = true
            label.isUserInteractionEnabled = false
            label.font = UIFont.systemFont(ofSize: CGFloat.random(in: 10...72))
            label.frame = CGRect(x: CGFloat.random(in: 0..<parentView.frame.width), y: -72, width: 120, height: 48)
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0..<3)) {
                parentView.addSubview(label)
                let gravity = UIGravityBehavior(items: [label])
                let animator = UIDynamicAnimator()
                animator.addBehavior(gravity)
                self.animators.append(animator)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            parentView.removeFromSuperview()
            self.animators.forEach({ $0.removeAllBehaviors() })
            self.isAnimating = false
        }
    }
}
