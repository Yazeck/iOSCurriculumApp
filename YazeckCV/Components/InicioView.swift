//
//  InicioView.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//

import SwiftUI

struct InicioView: View {
    @State private var showBadge = false
    
    var body: some View {
        ZStack {
            // Fondo líquido DENTRO de la vista
            LiquidBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Saludo + rol
                    GlassCard {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.35))
                                    .frame(width: 64, height: 64)
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(.pink)
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("¡Hola! Soy Erick")
                                    .font(.title2.weight(.bold))
                                Text("iOS Developer")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }
                    
                    // Resumen rápido
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(.pink)
                                Text("Resumen rápido")
                                    .font(.headline)
                            }
                            Label("3dViewerApp Publicada en AppStore", systemImage: "app.badge")
                            Label("Swift, SwiftUI, SceneKit", systemImage: "swift")
                            Label("Back: Node, Express, MongoDB", systemImage: "server.rack")
                        }
                    }
                    
                    // Destacados (mini cards)
                    // Figura 3D interactiva (cubo)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "cube.transparent")
                                    .foregroundStyle(Color.grape)
                                Text("¡Podemos hacer lo que se imagine el cliente!")
                                    .font(.headline)
                            }
                            
                            InteractiveCubeView()
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.25), lineWidth: 1)
                                )
                        }
                    }

                    
                    // CTA navegación interna
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "hand.point.right.fill")
                                    .foregroundStyle(Color.neonMint)
                                Text("Explora mi CV")
                                    .font(.headline)
                            }
                            HStack {
                                NavigationLink {
                                    ProyectosView()
                                } label: {
                                    Label("Ver Proyectos", systemImage: "hammer")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                
                                NavigationLink {
                                    ContactoView()
                                } label: {
                                    Label("Contactar", systemImage: "paperplane")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                            .labelStyle(.titleAndIcon)
                        }
                    }
                    
                    // Mini badge divertido
                    if showBadge {
                        Text("🚀 ¡Listo para nuevos retos!")
                            .font(.caption.bold())
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(.white.opacity(0.4)))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(20)
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showBadge = true
            }
        }
        .navigationTitle("Inicio")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LiquidBackground()
        NavigationStack {
            InicioView()
        }
    }
}

// MARK: - Subview usado por InicioView
struct HighlightRow: View {
    var icon: String
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [.sunny, .bubblePink],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 44, height: 44)
                    .opacity(0.8)
                Image(systemName: icon)
                    .foregroundStyle(.white)
                    .font(.headline)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.bold())
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}
