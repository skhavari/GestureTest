//
//  ContentView.swift
//  Gestures
//
//  Created by Sam Khavari on 12/11/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Gesture Test").font(.largeTitle)
                NavigationLink { SwiftGestures() } label: { Icon("swift") }
                NavigationLink { UIKitGestures() } label: { Icon("uikit") }
            }
            .padding(.horizontal, 48)
        }
    }
    
    func Icon(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .cornerRadius(35)
        
    }
}

struct WithCloseButton: ViewModifier {

    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .safeAreaInset(edge: .top) {
                CloseButton()
            }

    }

    @ViewBuilder
    func CloseButton() -> some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .tint(.white)
            .clipShape(.circle)
        }
        .padding(.trailing)
    }
}

extension View {
    func withCloseButton() -> some View {
        modifier(WithCloseButton())
    }
}

#Preview {
    Home()
}
