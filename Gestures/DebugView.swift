//
//  DebugView.swift
//  Usable
//
//  Created by Sam Khavari on 12/11/24.
//

import SwiftUI


///
///
///
///
///
struct DebugView : View {
    var layer : Layer
    var g : Gestures
    
    init(_ layer: Layer, gestures : Gestures) {
        self.layer = layer
        self.g = gestures
    }
    
    var body : some View {
        VStack(alignment: .leading, spacing: 30) {
            DebugPanel(shouldAnimate: g.isDragging) {
                Text("Drag").bold()
                Text("P: \(layer.x, specifier: "%.1f"), \(layer.y, specifier: "%.1f")").font(.caption)
                Text("G: \(g.offset.x, specifier: "%.1f"), \(g.offset.y, specifier: "%.1f")").font(.caption)
            }

            DebugPanel(shouldAnimate: g.isMagnifying) {
                Text("Magnify").bold()
                Text("S: \(layer.width, specifier: "%.1f"), \(layer.height, specifier: "%.1f")").font(.caption)
                Text("G: \(g.scale, specifier: "%.1f")").font(.caption)
            }

            DebugPanel(shouldAnimate: g.isRotating) {
                Text("Rotate").bold()
                Text("R: \(layer.rotation.degrees, specifier: "%.1f")").font(.caption)
                Text("G: \(g.rotation.degrees, specifier: "%.1f")").font(.caption)
            }

            Spacer()
        }
        .padding(.top, 64)
        .padding(.leading, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .allowsHitTesting(false)
    }
    
    @ViewBuilder
    private func DebugPanel<Content: View>(shouldAnimate: Bool = false, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading) {
            content()
        }
        .padding()
        .frame(width: 150, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
        .scaleEffect(shouldAnimate ? 1.2 : 1, anchor: .leading)
        .foregroundStyle(shouldAnimate ? .white : .primary)
        .bold()
    }
}

#Preview("Swift") {
    SwiftGestures()
}

#Preview("UIKit") {
    UIKitGestures()
}
