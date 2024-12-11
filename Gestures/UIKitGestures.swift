//
//  ContentView.swift
//  Usable
//
//  Created by Sam Khavari on 12/10/24.
//

import SwiftUI

protocol PanRotatePinchHandler {
    func panUpdate(offset: CGPoint)
    func panEnd(offset: CGPoint)
    func rotateUpdate(rotation: Angle)
    func rotateEnd(rotation: Angle)
    func pinchUpdate(scale: CGFloat)
    func pinchEnd(scale: CGFloat)
}




struct UIKitGestures: View, PanRotatePinchHandler {

    // layer state
    @State private var layer: Layer = Layer(
        image: "dog.fill",
        x: UIScreen.main.bounds.midX,
        y: UIScreen.main.bounds.midY,
        width: 400,
        height: 400,
        rotation: .degrees(-20)
    )

    // tracks values while gesture is in progress
    @State private var gOffset: CGPoint = .zero
    @State private var gRotation: Angle = .zero
    @State private var gScale: CGFloat = 1.0

    @State private var isPanning = false
    @State private var isPinching = false
    @State private var isRotating = false

    @State private var showToolbar = false

    var body: some View {

        ZStack {
            Image(systemName: layer.image)
                .resizable()
                .scaledToFill()
                .foregroundStyle(.orange.gradient)
                .border(.blue)
                .overlay { GestureRecognizer(size: layer.size, gestureHandler: self) }
                .rotationEffect(layer.rotation + gRotation)
                .frame(width: layer.width * gScale, height: layer.height * gScale)
                .position(x: layer.x + gOffset.x, y: layer.y + gOffset.y)
            DebugView(layer, gestures: gestures)

        }
        .ignoresSafeArea(.all)
        .background(.black.gradient.opacity(0.9))
        .withCloseButton()
    }

    // MARK: - Gesture Handling

    func panUpdate(offset: CGPoint) {
        gOffset = offset
        isPanning = true
    }

    func panEnd(offset: CGPoint) {
        layer.x += offset.x
        layer.y += offset.y
        gOffset = .zero
        isPanning = false
    }

    func rotateUpdate(rotation: Angle) {
        gRotation = rotation
        isRotating = true
    }

    func rotateEnd(rotation: Angle) {
        layer.rotation += rotation
        gRotation = .zero
        isRotating = false
    }

    func pinchUpdate(scale: CGFloat) {
        gScale = scale
        isPinching = true
    }

    func pinchEnd(scale: CGFloat) {
        layer.width *= scale
        layer.height *= scale
        gScale = 1.0
        isPinching = false
    }

    var gestures: Gestures {
        Gestures(
            offset: gOffset,
            scale: gScale,
            rotation: gRotation,
            isDragging: isPanning,
            isMagnifying: isPinching,
            isRotating: isRotating
        )
    }

    var gestureInProgress: Bool {
        isPanning || isRotating || isPinching
    }
}


///
///
///
///
///
struct GestureRecognizer: UIViewRepresentable {

    var size: CGSize
    var gestureHandler: PanRotatePinchHandler

    init( size: CGSize, gestureHandler: PanRotatePinchHandler ) {
        self.size = size
        self.gestureHandler = gestureHandler
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let rotate = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleRotation))
        view.addGestureRecognizer(rotate)

        let pan = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan))
        pan.delegate = context.coordinator
        pan.maximumNumberOfTouches = 2
        view.addGestureRecognizer(pan)

        let pinch = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch))
        pinch.delegate = context.coordinator
        view.addGestureRecognizer(pinch)

        return view
    }

    func updateUIView(_ view: UIView, context: Context) {}

    ///
    ///
    ///
    ///
    class Coordinator: NSObject, UIGestureRecognizerDelegate {

        ///
        var parent: GestureRecognizer

        init(_ parent: GestureRecognizer) {
            self.parent = parent
        }

        @objc func handleRotation(rotate: UIRotationGestureRecognizer) {
            if rotate.state == .began || rotate.state == .changed {
                parent.gestureHandler.rotateUpdate(rotation: .radians(rotate.rotation))
            } else {
                parent.gestureHandler.rotateEnd(rotation: .radians(rotate.rotation))
            }
        }

        @objc func handlePan(pan: UIPanGestureRecognizer) {
            if pan.state == .began || pan.state == .changed {
                if let view = pan.view {
                    // NOTE - this is specific to our app
                    let translation = pan.translation(in: view.superview!.superview)
                    parent.gestureHandler.panUpdate(offset: translation)
                }
            } else {
                if let view = pan.view {
                    let translation = pan.translation(in: view.superview!.superview)
                    parent.gestureHandler.panEnd(offset: translation)
                }
            }
        }

        @objc func handlePinch(pinch: UIPinchGestureRecognizer) {
            if pinch.state == .began || pinch.state == .changed {
                parent.gestureHandler.pinchUpdate(scale: pinch.scale)
            } else {
                parent.gestureHandler.pinchEnd(scale: pinch.scale)
            }
        }

        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            true
        }
    }
}

#Preview {
    UIKitGestures()
}
