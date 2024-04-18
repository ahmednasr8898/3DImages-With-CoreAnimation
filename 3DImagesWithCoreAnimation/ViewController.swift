//
//  ViewController.swift
//  3DImagesWithCoreAnimation
//
//  Created by Nasr on 12/05/2022.
//

import UIKit

func degreeToRadians(degree: CGFloat) -> CGFloat{
    return (degree * CGFloat.pi)/180
}

class ViewController: UIViewController {
    
    // MARK: Proprites
    
    var transformLayer = CATransformLayer()
    var currentAngle: CGFloat = 0
    var currentOffset: CGFloat = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurations()
        configureTapAction()
    }
}


// MARK: Configurations

extension ViewController {
    private func configurations() {
        transformLayer.frame = self.view.bounds
        view.layer.addSublayer(transformLayer)
        
        for i in 1...10 {
            setImageCard(imageName: "\(i)")
        }
        
        turnCarousal()
    }
    
    private func configureTapAction() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.performPanAction(recognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func performPanAction(recognizer: UIPanGestureRecognizer) {
        let xOffset = recognizer.translation(in: self.view).x
        
        if recognizer.state == .began{
            currentOffset = 0
        }
        
        let xDifference = xOffset * 0.6 - currentOffset
        
        currentOffset += xDifference
        currentAngle += xDifference
        
        turnCarousal()
    }
}


// MARK: Private handlers

extension ViewController {
    private func turnCarousal() {
        guard let transformSublayers = transformLayer.sublayers else {return}
        
        let segmentForImageCard = CGFloat(360 / transformSublayers.count)
        
        var angleOffset = currentAngle
        
        for layer in transformSublayers{
            
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            transform = CATransform3DRotate(transform, degreeToRadians(degree: angleOffset), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            CATransaction.setAnimationDuration(0)
            
            layer.transform = transform
            angleOffset += segmentForImageCard
        }
    }
    
    private func setImageCard(imageName: String){
        
        let imageCardSize = CGSize(width: 200, height: 300)
        
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: view.frame.size.width / 2 - imageCardSize.width / 2, y: view.frame.size.height / 2 - imageCardSize.height / 2, width: imageCardSize.width, height: imageCardSize.height)
    
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        guard let imageCardImage = UIImage(named: imageName)?.cgImage else {return}
        
        imageLayer.contents = imageCardImage
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.masksToBounds = true
        imageLayer.isDoubleSided = true
        imageLayer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        imageLayer.borderWidth = 5
        imageLayer.cornerRadius = 10
        
        transformLayer.addSublayer(imageLayer)
    }
}
 
