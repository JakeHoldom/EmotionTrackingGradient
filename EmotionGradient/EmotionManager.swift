//
//  EmotionManager.swift
//  EmotionGradient
//
//  Created by Jake Holdom on 12/09/2019.
//  Copyright © 2019 Jake Holdom. All rights reserved.
//

import UIKit
import ARKit

class EmotionManager {
    
    // List of all of the emotions we want to track
    private var emotions: [Emotion] = [NeutralEmotion(), HappyEmotion(), SadEmotion(), AngryEmotion()]
    
    // Current active emotions. Defaults to neutral.
    var activeEmotions: [Emotion] = [NeutralEmotion()]
    
    // Gets the current emotions found in the given ARFaceAnchor object. If none are found then return neutral as default.
    func refreshActiveEmotions(for face: ARFaceAnchor) {
        
        var activeEmotions = [Emotion]()
        
        for emotion in self.emotions {
            if emotion.isActive(for: face) {
                activeEmotions.append(emotion)
            }
        }
        
        // If no active emotions are found then default to neutral
        self.activeEmotions = activeEmotions.isEmpty ? [NeutralEmotion()] : activeEmotions
    }
    
    // Return emotion colors from currently active face emotions. Shuffle the order so the gradient constantly changes.
    func getEmotionColors() -> [CGColor] {
        return activeEmotions.flatMap { $0.colors.compactMap { $0.cgColor } }.shuffled()
    }
}
