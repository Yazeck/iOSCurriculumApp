//
//  ContactoView.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//

import SwiftUI

struct ContactoView: View {
    @State private var showCopied = false
    @State private var showThanks = false
    
    var body: some View {
        ZStack {
            // Fondo líquido detrás de todo
            LiquidBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Card principal de contacto
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "paperplane.fill")
                                    .foregroundStyle(.pink)
                                Text("¡Hablemos! 👋")
                                    .font(.title3.bold())
                            }
                            
                            Text("¿Tienes un proyecto, vacante o idea interesante? Me encantaría conocerla. 😊")
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Divider().opacity(0.3)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(Color.bubblePink)
                                Text("e.yazeck@gmail.com")
                                    .font(.body.monospaced())
                                Spacer()
                                Button {
                                    UIPasteboard.general.string = "e.yazeck@gmail.com"
                                    withAnimation { showCopied = true }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                                        withAnimation { showCopied = false }
                                    }
                                } label: {
                                    Label("Copiar", systemImage: "doc.on.doc.fill")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    
                    // Redes sociales
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "link.circle.fill")
                                    .foregroundStyle(Color.neonMint)
                                Text("Redes")
                                    .font(.headline)
                            }
                            
                            LinkRow(icon: "chevron.left.slash.chevron.right", title: "GitHub", url: "https://github.com/yazeck")
                            LinkRow(icon: "link", title: "LinkedIn", url: "https://www.linkedin.com/in/erick-nungaray")
                            LinkRow(icon: "message.fill", title: "WhatsApp", url: "https://wa.me/5213317998107")
                        }
                    }
                    
                    // Formulario simpático
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "text.bubble.fill")
                                    .foregroundStyle(Color.sunny)
                                Text("Envíame un mensaje rápido")
                                    .font(.headline)
                            }
                            
                            TextField("Tu nombre", text: .constant(""))
                                .textFieldStyle(.roundedBorder)
                            TextField("Tu correo", text: .constant(""))
                                .textFieldStyle(.roundedBorder)
                            TextField("Tu mensaje", text: .constant(""))
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                withAnimation(.spring()) { showThanks.toggle() }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                    withAnimation { showThanks = false }
                                }
                            } label: {
                                Label("Enviar ✨", systemImage: "paperplane.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        if showThanks {
                            Text("¡Gracias por tu mensaje! 💌")
                                .font(.caption.bold())
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(.white.opacity(0.4)))
                                .padding(.top, 10)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                }
                .padding(20)
            }
            // 🔑 Quita el fondo blanco del ScrollView
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .overlay(alignment: .top) {
            if showCopied {
                Text("¡Correo copiado!")
                    .font(.caption.bold())
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.4)))
                    .padding(.top, 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("Contacto")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

// MARK: - Subview para enlaces
private struct LinkRow: View {
    var icon: String
    var title: String
    var url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: 26, height: 26)
                Text(title)
                    .font(.body.weight(.medium))
                Spacer()
                Image(systemName: "arrow.up.right.circle.fill")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LiquidBackground()
        NavigationStack {
            ContactoView()
        }
    }
}
