//
//
//
//
//

import SwiftUI

///
///
///
struct SwiftGestures: View {

    

    // Layer state
    @State private var layer: Layer = Layer(
        image: "cat.fill",
        x: UIScreen.main.bounds.midX,
        y: UIScreen.main.bounds.midY,
        width: 400,
        height: 400,
        rotation: .degrees(-20)
    )

    // Gesture State
    @GestureState private var gOffset: CGPoint = .zero
    @GestureState private var gScale: CGFloat = 1.0
    @GestureState private var gRotation: Angle = .degrees(0)
    @State private var isDragging = false
    @State private var isMagnifying = false
    @State private var isRotating = false

    let animation: Animation = .bouncy(duration: 0.25)

    var body: some View {
        ZStack {
            Image(systemName: layer.image)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.orange.gradient)
                .border(.blue.gradient.opacity(0.5))
                .rotationEffect(layer.rotation + gRotation)
                .frame(width: layer.width * gScale, height: layer.height * gScale)
                .position(x: layer.x + gOffset.x, y: layer.y + gOffset.y)
                .gesture(drag().simultaneously(with: magnify().simultaneously(with: rotate())))
            DebugView(layer, gestures: gestures)
        }
        .background(.black.gradient.opacity(0.9))
        .ignoresSafeArea(edges: .all)
        .withCloseButton()
    }

    private func drag() -> some Gesture {
        DragGesture()
            .updating($gOffset) { value, state, transaction in
                state = .init(x: value.translation.width, y: value.translation.height)
                if isDragging { return }
                transaction.animation = animation
                withTransaction(transaction) { isDragging = true }
            }
            .onEnded { value in
                self.layer.x += value.translation.width
                self.layer.y += value.translation.height
                withAnimation(animation) { isDragging = false }
            }
    }

    private func magnify() -> some Gesture {
        MagnifyGesture(minimumScaleDelta: 0)
            .updating($gScale) { value, state, transaction in
                state = value.magnification
                if isMagnifying { return }
                transaction.animation = animation
                withTransaction(transaction) { isMagnifying = true }
            }
            .onEnded { value in
                self.layer.width *= value.magnification
                self.layer.height *= value.magnification
                withAnimation(animation) { isMagnifying = false }
            }
    }

    private func rotate() -> some Gesture {
        RotateGesture()
            .updating($gRotation) { value, state, transaction in
                guard !value.rotation.degrees.isNaN else {
                    print("💣 rotation value is NaN 💩🤮🤬")
                    print(value)
                    return
                }
                state = value.rotation

                if isRotating { return }
                transaction.animation = animation
                withTransaction(transaction) { isRotating = true }
            }
            .onEnded { value in
                self.layer.rotation += value.rotation.degrees.isNaN ? gRotation : value.rotation
                withAnimation(animation) { isRotating = false }
            }
    }

    var gestures: Gestures {
        Gestures(
            offset: gOffset,
            scale: gScale,
            rotation: gRotation,
            isDragging: isDragging,
            isMagnifying: isMagnifying,
            isRotating: isRotating
        )
    }

}

#Preview {
    SwiftGestures()
}
