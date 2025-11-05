//
//  LiquidBackground.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//

import SwiftUI

struct LiquidBackground: View {
    @State private var animate = false
    var showBubbles: Bool = true
    var bubbleCount: Int = 20  // AÚN MÁS burbujas

    var body: some View {
        ZStack {
            // Gradiente base
            LinearGradient(
                colors: [.bubblePink.opacity(0.35), .skyPop.opacity(0.35)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Círculos grandes originales
            Circle()
                .fill(.white.opacity(0.20))
                .blur(radius: 60)
                .frame(width: 260, height: 260)
                .offset(x: animate ? 130 : -140, y: animate ? -180 : 160)
                .animation(.easeInOut(duration: 12).repeatForever(autoreverses: true), value: animate)

            Circle()
                .fill(Color.neonMint.opacity(0.25))
                .blur(radius: 80)
                .frame(width: 300, height: 300)
                .offset(x: animate ? -160 : 120, y: animate ? 170 : -150)
                .animation(.easeInOut(duration: 14).repeatForever(autoreverses: true), value: animate)

            Circle()
                .fill(Color.grape.opacity(0.20))
                .blur(radius: 70)
                .frame(width: 280, height: 280)
                .offset(x: animate ? 40 : -40, y: animate ? 220 : -220)
                .animation(.easeInOut(duration: 18).repeatForever(autoreverses: true), value: animate)
            
            // Burbujas adicionales - MÁS VISIBLES
            if showBubbles {
                GeometryReader { geometry in
                    ZStack {
                        ForEach(0..<bubbleCount, id: \.self) { index in
                            AnimatedBubble(
                                index: index,
                                containerSize: geometry.size
                            )
                        }
                    }
                    .allowsHitTesting(false)
                }
            }
        }
        .onAppear { animate = true }
    }
}

private struct AnimatedBubble: View {
    let index: Int
    let containerSize: CGSize
    
    @State private var position: CGPoint = .zero
    @State private var size: CGFloat = 150
    @State private var opacity: Double = 0.5
    
    private var colors: [Color] {
        [.bubblePink, .neonMint, .skyPop, .grape, .sunny]
    }
    
    private var color: Color {
        colors[index % colors.count]
    }
    
    var body: some View {
        ZStack {
            // Círculo con color sólido BRILLANTE (sin blur para debug)
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .opacity(0.9)  // MUY visible
            
            // Borde blanco para verlas fácil
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: size, height: size)
        }
        .position(position)
        .onAppear {
            setupInitialState()
            startAnimation()
        }
    }
    
    private func setupInitialState() {
        guard containerSize.width > 0, containerSize.height > 0 else { return }
        let seed = index * 1000
        position = CGPoint(
            x: pseudoRandom(seed: seed) * containerSize.width,
            y: pseudoRandom(seed: seed + 1) * containerSize.height
        )
        size = 150 + pseudoRandom(seed: seed + 2) * 200  // Burbujas MUY grandes
        opacity = 0.6 + pseudoRandom(seed: seed + 9) * 0.3  // MÁS opacidad
    }
    
    private func startAnimation() {
        guard containerSize.width > 0, containerSize.height > 0 else { return }
        let seed = index * 1000
        let duration = 15.0 + pseudoRandom(seed: seed + 3) * 10.0  // Más lento
        let delay = pseudoRandom(seed: seed + 4) * 2.0
        
        // Animación de posición
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true)
            ) {
                let newX = pseudoRandom(seed: seed + 5) * containerSize.width
                let newY = pseudoRandom(seed: seed + 6) * containerSize.height
                position = CGPoint(x: newX, y: newY)
            }
        }
        
        // Animación de tamaño
        let pulseDuration = 8.0 + pseudoRandom(seed: seed + 7) * 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay * 0.5) {
            withAnimation(
                .easeInOut(duration: pulseDuration)
                .repeatForever(autoreverses: true)
            ) {
                let scale = 0.8 + pseudoRandom(seed: seed + 8) * 0.5
                size = (150 + pseudoRandom(seed: seed + 2) * 200) * scale
            }
        }
        
        // Animación de opacidad - más visible
        DispatchQueue.main.asyncAfter(deadline: .now() + delay * 0.3) {
            withAnimation(
                .easeInOut(duration: 6.0)
                .repeatForever(autoreverses: true)
            ) {
                opacity = 0.5 + pseudoRandom(seed: seed + 10) * 0.35
            }
        }
    }
    
    private func pseudoRandom(seed: Int) -> CGFloat {
        let x = sin(Double(seed)) * 10000
        return CGFloat(x - floor(x))
    }
}

#Preview {
    LiquidBackground()
        .overlay(
            Text("Fondo líquido")
                .font(.title.bold())
                .padding()
                .background(.ultraThinMaterial, in: Capsule())
        )
}
