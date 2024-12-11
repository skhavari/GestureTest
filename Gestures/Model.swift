//
//  Model.swift
//  Usable
//
//  Created by Sam Khavari on 12/11/24.
//

import SwiftUI



struct Layer {
    var image : String
    var x : CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    var rotation: Angle
    
    init(image: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, rotation: Angle) {
        self.image = image
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotation = rotation
    }
    
    var size : CGSize {
        .init(width: width, height: height)
    }
}

struct Gestures {
    var offset: CGPoint = .zero
    var scale: CGFloat = 1.0
    var rotation: Angle = .degrees(0)
    var isDragging = false
    var isMagnifying = false
    var isRotating = false
}
