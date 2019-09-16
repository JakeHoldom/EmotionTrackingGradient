//
//  ViewController.swift
//  EmotionGradient
//
//  Created by Jake Holdom on 12/09/2019.
//  Copyright © 2019 Jake Holdom. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    var emotionManager = EmotionManager()
    var gradientView : CAGradientLayer?
    
    @IBOutlet weak var trackingView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking not available on this on this device model!")
        }
        let configuration = ARFaceTrackingConfiguration()
        self.trackingView.session.run(configuration)
        self.trackingView.delegate = self

        self.initialiseGradient()
        self.animateGradient()
    }

    func initialiseGradient() {
        // Create gradient view to take up whole of the background view
        self.gradientView = CAGradientLayer()
        self.gradientView?.startPoint = CGPoint(x: 0, y: 0) // Starts in top left corner
        self.gradientView?.endPoint = CGPoint(x: 1, y: 1) // Ends in bottom right corner
        
        self.gradientView?.frame = self.view.frame
        
        self.gradientView?.colors = emotionManager.getEmotionColors()
        view.layer.insertSublayer(self.gradientView!, at: 0)
    }
    
    func animateGradient() {
        // Animates gradient from current gradient colors to current emotion colors
        let colorArray = self.emotionManager.getEmotionColors()
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 1
        animation.fromValue = self.gradientView!.colors
        animation.toValue = colorArray
        animation.delegate = self
        self.gradientView?.add(animation, forKey: nil)
        DispatchQueue.main.async {
            CATransaction.setDisableActions(true)
            self.gradientView?.colors = colorArray
        }
    }
}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        DispatchQueue.main.async {
            // Run new gradient animation once the previous has finished to create the endless gradient movement effect
            self.animateGradient()
        }
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        DispatchQueue.main.async {
            self.emotionManager.refreshActiveEmotions(for: faceAnchor)
        }
    }
}
