//
//  ProyectosView.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//

import SwiftUI

struct ProyectosView: View {
    var body: some View {
        ZStack {
            // Fondo líquido detrás de todo
            LiquidBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Encabezado
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "hammer.fill")
                                    .foregroundStyle(.pink)
                                Text("Proyectos")
                                    .font(.title3.bold())
                            }
                            Text("Algunos trabajos y demos que representan mi estilo: UIs coloridas, glassmorphism y buen performance.")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    // 3DViewer
                    ProjectCard(title: "3DViewer",
                                subtitle: "SwiftUI + SceneKit",
                                icon: "cube.transparent") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Visor STL con navegación cíclica, cambio de color y autoescalado para distintos modelos.")
                            HStack {
                                Link(destination: URL(string: "https://github.com/yazeck")!) {
                                    Label("Código", systemImage: "chevron.left.slash.chevron.right")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                
                                NavigationLink {
                                    ProjectDetailView(
                                        title: "3DViewer",
                                        bullets: [
                                            "Carga y render de STL con SceneKit",
                                            "Autoescalado al viewport",
                                            "Cambio dinámico de color",
                                            "Controles táctiles intuitivos"
                                        ]
                                    )
                                } label: {
                                    Label("Detalles", systemImage: "info.circle")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .labelStyle(.titleAndIcon)
                        }
                    }
                    
                    // Chambafy (MERN)
                    ProjectCard(title: "Chambafy",
                                subtitle: "MERN",
                                icon: "tshirt.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Aplicación para publicar y aplicar a trabajos.")
                            HStack {
                                Link(destination: URL(string: "https://github.com/yazeck")!) {
                                    Label("Repo", systemImage: "tray.full.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                
                                NavigationLink {
                                    ProjectDetailView(
                                        title: "Chambafy",
                                        bullets: [
                                            "Auth0",
                                            "Panel Admin, empleador y aplicante",
                                            "Base de datos con MongoDB",
                                            "Foco en UX moderna"
                                        ]
                                    )
                                } label: {
                                    Label("Detalles", systemImage: "info.circle")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .labelStyle(.titleAndIcon)
                        }
                    }
                    
                    // AppITZFood
                    ProjectCard(title: "AppITZFood",
                                subtitle: "React + Auth0 + Node/Express/Mongo",
                                icon: "fork.knife.circle.fill") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Autenticación con Auth0, perfil de usuario y conexión a backend Node/Express/MongoDB.")
                            HStack {
                                Link(destination: URL(string: "https://github.com/yazeck")!) {
                                    Label("Código", systemImage: "chevron.left.slash.chevron.right")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                
                                NavigationLink {
                                    ProjectDetailView(
                                        title: "AppITZFood",
                                        bullets: [
                                            "Login/SignUp con Auth0",
                                            "Protección de rutas",
                                            "Perfil y edición de usuario",
                                            "API REST con Express y MongoDB"
                                        ]
                                    )
                                } label: {
                                    Label("Detalles", systemImage: "info.circle")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .labelStyle(.titleAndIcon)
                        }
                    }
                    
                    // CTA final
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.neonMint)
                                Text("¿Quieres ver más?")
                                    .font(.headline)
                            }
                            HStack {
                                Link(destination: URL(string: "https://github.com/yazeck")!) {
                                    Label("GitHub", systemImage: "chevron.left.slash.chevron.right")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                
                                NavigationLink {
                                    ContactoView()
                                } label: {
                                    Label("Contáctame", systemImage: "paperplane")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                            .labelStyle(.titleAndIcon)
                        }
                    }
                }
                .padding(20)
            }
            // 🔑 Transparencia del ScrollView (sin fondo blanco)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle("Proyectos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

// MARK: - Vista de detalle reutilizable (mini)
private struct ProjectDetailView: View {
    var title: String
    var bullets: [String]
    
    var body: some View {
        ZStack {
            LiquidBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "info.circle.fill")
                                    .foregroundStyle(.pink)
                                Text(title)
                                    .font(.title3.bold())
                            }
                            ForEach(bullets, id: \.self) { item in
                                Bullet(item)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

// MARK: - Bullet (reutilizado)
private struct Bullet: View {
    var text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .imageScale(.medium)
                .foregroundStyle(.green)
            Text(LocalizedStringKey(text))
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LiquidBackground()
        NavigationStack {
            ProyectosView()
        }
    }
}
