//
//  HabilidadesView.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//



import SwiftUI

struct HabilidadesView: View {
    @State private var selectedGroup: SkillGroup = .ios
    @State private var showDetails: Bool = true
    
    var body: some View {
        ZStack {
            // Fondo líquido visible detrás del contenido
            LiquidBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Selector de grupos
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "wand.and.stars")
                                    .foregroundStyle(.pink)
                                Text("Habilidades")
                                    .font(.headline)
                            }
                            Picker("Grupo", selection: $selectedGroup) {
                                ForEach(SkillGroup.allCases, id: \.self) { group in
                                    Text(group.title).tag(group)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            Toggle(isOn: $showDetails) {
                                Label("Mostrar detalles", systemImage: "list.bullet.rectangle.portrait")
                            }
                            .tint(.grape)
                        }
                    }
                    
                    // Etiquetas rápidas según grupo
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Stack principal")
                                .font(.headline)
                            FlexibleTags(tags: selectedGroup.tags)
                        }
                    }
                    
                    // Métricas/medidores por grupo
                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Dominio por área")
                                .font(.headline)
                            ForEach(selectedGroup.meters, id: \.title) { meter in
                                SkillMeter(title: meter.title, level: meter.level)
                            }
                        }
                    }
                    
                    // Detalles / bullets
                    if showDetails {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Fortalezas")
                                    .font(.headline)
                                Bullet("UI/UX llamativa con **glassmorphism** y animaciones fluidas.")
                                Bullet("Arquitectura **MVVM**, separación por capas y limpieza de código.")
                                Bullet("Prototipado rápido y demos **ready-to-show**.")
                                Bullet("Integración con backend (**REST**, JSON), manejo de estados y errores.")
                            }
                        }
                        
                        // Soft skills
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Soft skills")
                                    .font(.headline)
                                FlexibleTags(tags: [
                                    "Comunicación", "Trabajo en equipo", "Resolución de problemas",
                                    "Aprendizaje continuo", "Autonomía", "Enfoque al detalle"
                                ])
                            }
                        }
                    }
                    
                    // CTA a proyectos relacionados
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "hammer")
                                    .foregroundStyle(Color.neonMint)
                                Text("Explorar ejemplos")
                                    .font(.headline)
                            }
                            HStack {
                                NavigationLink {
                                    ProyectosView()
                                } label: {
                                    Label("Ver Proyectos", systemImage: "list.bullet.rectangle")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                
                                NavigationLink {
                                    PerfilView()
                                } label: {
                                    Label("Sobre mí", systemImage: "person.crop.circle")
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
            // 🔑 Clave para que no pinte el blanco por defecto
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle("Skills")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

// MARK: - Modelos simples para el view

enum SkillGroup: CaseIterable {
    case ios, backend, web
    
    var title: String {
        switch self {
        case .ios: return "iOS"
        case .backend: return "Backend"
        case .web: return "Web"
        }
    }
    
    var tags: [String] {
        switch self {
        case .ios:
            return ["Swift", "SwiftUI", "Firebase", "SceneKit", "UIKit", "MVVM"]
        case .backend:
            return ["Node", "Express", "MongoDB", "REST", "Auth (JWT)"]
        case .web:
            return ["React", "Vite", "Tailwind", "TypeScript", "UI Components"]
        }
    }
    
    var meters: [(title: String, level: Double)] {
        switch self {
        case .ios:
            return [("Swift", 0.85), ("SwiftUI", 0.85), ("Firebase", 0.8), ("SceneKit", 0.7), ("UIKit", 0.6)]
        case .backend:
            return [("Node/Express", 0.65), ("MongoDB", 0.6), ("REST/JSON", 0.75)]
        case .web:
            return [("React", 0.65), ("Vite", 0.6), ("Tailwind", 0.7), ("TypeScript", 0.55)]
        }
    }
}

// MARK: - Subviews

private struct SkillMeter: View {
    var title: String
    var level: Double // 0...1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Int(level * 100))%")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.opacity(0.18))
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(LinearGradient(colors: [.skyPop, .grape], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 10)
                    .mask(
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 10).frame(width: geo.size.width * level)
                        }
                    )
            }
        }
    }
}

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
            HabilidadesView()
        }
    }
}
