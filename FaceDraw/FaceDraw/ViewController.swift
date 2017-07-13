//
//  ViewController.swift
//  FaceDraw
//
//  Created by Jonathan Deng on 7/9/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let pinchHandler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: pinchHandler)
            faceView.addGestureRecognizer(pinchRecognizer)
            let tapHandler = #selector(self.toggleEyes(byReactingTo:))
            let tapRecognizer = UITapGestureRecognizer(target: self, action: tapHandler)
            tapRecognizer.numberOfTapsRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeUpRecognizer.direction = .up
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeUpRecognizer)
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }
    

    // did set not called on intialization
    var expression: FacialExpression = FacialExpression(eyes: .closed, mouth: .frown
        ) {
        didSet {
            updateUI()
        }
    }
    
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = expression.eyes == .closed ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    func increaseHappiness() {
        expression = expression.happier
    }
    
    func decreaseHappiness() {
        expression = expression.sadder
    }
    
    private func updateUI() {
        // we use options for faceview, because if the outlet is not set, trying to access it will cause program to crash
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case.squinting:
            faceView?.eyesOpen = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0
    }
    
    // mapping between mouth curvatures and a value that the UI uses
    private let mouthCurvatures = [
        FacialExpression.Mouth.grin: 0.5,
        FacialExpression.Mouth.smile: 1.0,
        FacialExpression.Mouth.frown: -1.0,
        FacialExpression.Mouth.neutral: 0,
        FacialExpression.Mouth.smirk: -0.5,
    ]
    
}

