//
//  Emotion.swift
//  EmotionGradient
//
//  Created by Jake Holdom on 16/09/2019.
//  Copyright © 2019 Jake Holdom. All rights reserved.
//

import UIKit
import ARKit

protocol Emotion {
    // The range between 0-1 where the emotion is considered active or not
    var threshold: Double { get }
    
    // List of colors associated with the emotion
    var colors: [UIColor] { get }
    
    // Calculated from the the blendshapes to see if that face has the given emotion (for example smile is calculated from '.mouthSmileLeft' or '.mouthSmileRight' being over the threshold amount)
    func isActive(for face: ARFaceAnchor) -> Bool
}

extension Emotion {
    // Set default threshold to 0.3, can be overriden by class to change value.
    var threshold: Double {
        return 0.3
    }
}

struct NeutralEmotion: Emotion {
    var colors: [UIColor] = [UIColor(hexString: "#9CC0E7"), UIColor(hexString: "#EEEEEE"), UIColor(hexString: "#FCFCFC"), UIColor(hexString: "#F7DBD7")]
    
    func isActive(for face: ARFaceAnchor) -> Bool {
        for blendshape in face.blendShapes {
            if blendshape.value.doubleValue > self.threshold {
                return false
            }
        }
        return true
    }
}

struct HappyEmotion: Emotion {
    var colors: [UIColor] = [UIColor(hexString: "#01BEFE"), UIColor(hexString: "#FFDD00"), UIColor(hexString: "#ADFF02"), UIColor(hexString: "#E7B2FF")]
    
    func isActive(for face: ARFaceAnchor) -> Bool {
        return face.blendShapes[.mouthSmileLeft]?.doubleValue ?? 0 > self.threshold || face.blendShapes[.mouthSmileRight]?.doubleValue ?? 0 > self.threshold
    }
}

struct SadEmotion: Emotion {
    var colors: [UIColor] = [UIColor(hexString: "#345467"), UIColor(hexString: "#101442"), UIColor(hexString: "#1F6B65"), UIColor(hexString: "#1D4E7A")]
    
    func isActive(for face: ARFaceAnchor) -> Bool {
        return face.blendShapes[.mouthFrownLeft]?.doubleValue ?? 0 > self.threshold || face.blendShapes[.mouthFrownRight]?.doubleValue ?? 0 > self.threshold
    }
}

struct AngryEmotion: Emotion {
    var colors: [UIColor] = [UIColor(hexString: "#E72222"), UIColor(hexString: "#C92929"), UIColor(hexString: "#AB3232"), UIColor(hexString: "#963232")]
    
    func isActive(for face: ARFaceAnchor) -> Bool {
        
        return face.blendShapes[.browDownRight]?.doubleValue ?? 0 > self.threshold || face.blendShapes[.browDownLeft]?.doubleValue ?? 0 > self.threshold
    }
}
