//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import UIKit

open class SkeletonView: UIView {
    public private(set) weak var maskingView: UIView?
    public private(set) weak var view: UIView?
            
    public private(set) lazy var skeletonLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }()
    
    override open var bounds: CGRect {
        didSet { setupLayers() }
    }
    
    open func setupLayers() {
        guard let maskingView = maskingView else { return }
        
        layer.backgroundColor = Appearance.default.colorPalette.textLowEmphasis.cgColor
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
        
        if let label = view as? UILabel {
            label.textColor = .clear
        }
        skeletonLayer.frame = maskingView.layer.bounds
        
        skeletonLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        skeletonLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        skeletonLayer.locations = [-1.0, -0.5, 0.0]

        skeletonLayer.colors = [
            Appearance.default.colorPalette.background.cgColor,
            Appearance.default.colorPalette.overlayBackground.cgColor,
            Appearance.default.colorPalette.background.cgColor
        ]
    }
        
    // MARK: - Setup
    
    open func setup(with view: UIView?, maskingView: UIView?) {
        self.view = view
        self.maskingView = maskingView
        setupLayers()
        setupAnimation()
    }
    
    open func setupAnimation() {
        guard skeletonLayer.animation(forKey: "SkeletonAnimation") == nil else { return }
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 1.9]
        
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        
        skeletonLayer.add(animation, forKey: "SkeletonAnimation")
    }
}
