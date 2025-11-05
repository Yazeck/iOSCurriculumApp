//
//  PerfilView.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//

import SwiftUI

struct PerfilView: View {
    @State private var showCopied = false
    @State private var showConfetti = false

    // Animación tipo Instagram (tap para ampliar y tap para cerrar)
    @Namespace private var avatarNS
    @State private var showAvatarFull = false

    var body: some View {
        ZStack {
            // Fondo líquido detrás del contenido
            LiquidBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            ScrollView {
                VStack(spacing: 16) {

                    // Encabezado con avatar + nombre + rol
                    GlassCard {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.sunny.opacity(0.8), .bubblePink.opacity(0.8)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 100, height: 100)
                                        .shadow(radius: 10, y: 6)

                                    // Avatar pequeño: source solo cuando NO está abierto el fullscreen
                                    Image("erickavatar")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(.white.opacity(0.4), lineWidth: 2))
                                        .matchedGeometryEffect(id: "avatar", in: avatarNS, isSource: !showAvatarFull)
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                                                showAvatarFull = true
                                            }
                                        }
                                        .opacity(showAvatarFull ? 0 : 1) // evita ver doble
                                        .accessibilityLabel("Foto de Erick Yazeck")
                                }

                                Text("Erick Yazeck Nungaray")
                                    .font(.title3.bold())
                                Text("iOS & FullStack Developer")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                HStack(spacing: 8) {
                                    TagChip(label: "Zacatecas, MX", systemImage: "mappin.and.ellipse")
                                    TagChip(label: "Disponible", systemImage: "bolt.fill")
                                }
                            }
                            Spacer(minLength: 0)
                        }
                    }

                    // Sobre mí
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionTitle("Sobre mí", icon: "sparkles")
                            Text("""
Desarrollador iOS con foco en **SwiftUI** y experiencias **liquid glass**. \
Me gusta crear UIs intuitivas, accesibles y con buen rendimiento. \
Me gusta incluir elementos interactivos multimedia, y también exploro el stack **MERN** para proyectos personales.
""")
                            .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    // Educación
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionTitle("Educación", icon: "graduationcap.fill")
                            VStack(alignment: .leading, spacing: 8) {
                                EduRow(title: "Ing. en Sistemas", subtitle: "Instituto Tecnológico de Zacatecas", icon: "books.vertical.fill")
                                EduRow(title: "Apple Developer Academy", subtitle: "Certificación Oficial de Swift", icon: "apple.logo")
                            }
                        }
                    }

                    // Experiencia / logros breves
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle("Experiencia y logros", icon: "trophy.fill")
                            Bullet("3DViewer: visor de archivos STL con **SwiftUI + SceneKit**, cambio de color y auto-escalado. Publicada en AppStore")
                            Bullet("AppITZFood: **React + Auth0** con backend Node/Express/Mongo.")
                            Bullet("Experiencia en integración de Chatbots para CRM con Kommo y Prolog")
                            Bullet("Experiencia con sistemas embebidos PLC con control Web")
                        }
                    }

                    // Habilidades clave (chips)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionTitle("Tecnologías", icon: "wand.and.stars")
                            FlexibleTags(tags: [
                                "Swift", "SwiftUI", "SceneKit", "UIKit",
                                "NodeJs", "Express", "MongoDB", "React", "Tailwind"
                            ])
                            .accessibilityLabel("Etiquetas de habilidades")
                        }
                    }

                    // Intereses / rasgos personales
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionTitle("Me define", icon: "face.smiling")
                            FlexibleTags(tags: [
                                "UI/UX iOS 26", "Glassmorphism", "Animaciones suaves",
                                "Resolución de problemas", "Aprendizaje continuo",
                                "Prototipado rápido", "Trabajo en equipo"
                            ])
                        }
                    }

                    // Datos de contacto rápido (copiar mail)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionTitle("Contacto rápido", icon: "paperplane.fill")
                            VStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                Text("e.yazeck@gmail.com")
                                    .font(.body.monospaced())
                                Spacer()
                                Button {
                                    UIPasteboard.general.string = "e.yazeck@gmail.com"
                                    withAnimation { showCopied = true }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        withAnimation { showCopied = false }
                                    }
                                } label: {
                                    Label("Copiar", systemImage: "doc.on.doc.fill")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("Correo de contacto. Botón para copiar.")
                        }
                    }

                    // Botones de acción (descargar CV, ver GitHub / LinkedIn)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle("Acciones", icon: "rectangle.and.hand.point.up.left.filled")
                            VStack {
                                Button {
                                    showConfetti.toggle()
                                } label: {
                                    Label("Descargar CV (PDF)", systemImage: "arrow.down.doc.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)

                                Link(destination: URL(string: "https://github.com/yazeck")!) {
                                    Label("GitHub", systemImage: "chevron.left.slash.chevron.right")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)

                                Link(destination: URL(string: "https://www.linkedin.com/in/erick-nungaray")!) {
                                    Label("LinkedIn", systemImage: "link")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                            .labelStyle(.titleAndIcon)
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        if showConfetti {
                            ConfettiBurst()
                                .transition(.move(edge: .top).combined(with: .opacity))
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        withAnimation { showConfetti = false }
                                    }
                                }
                        }
                    }
                }
                .padding(20)
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)

            // Overlay fullscreen: grande al centro, tap para cerrar
            if showAvatarFull {
                ZStack {
                    Color.black.opacity(0.55)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                                showAvatarFull = false
                            }
                        }

                    Image("erickavatar")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 40,
                            height: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 40
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(radius: 24)
                        .matchedGeometryEffect(id: "avatar", in: avatarNS, isSource: true)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                                showAvatarFull = false
                            }
                        }
                }
                .transition(.identity) // el morph lo hace matchedGeometry
                .zIndex(10)
            }
        }
        .overlay(alignment: .top) {
            if showCopied {
                Text("¡Correo copiado!")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.4)))
                    .padding(.top, 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }

    // MARK: - Subviews (internos para mantener el estilo)

    private struct SectionTitle: View {
        var text: String
        var icon: String
        init(_ text: String, icon: String) {
            self.text = text; self.icon = icon
        }
        var body: some View {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .imageScale(.medium)
                    .foregroundStyle(.pink)
                Text(LocalizedStringKey(text))
                    .font(.headline)
            }
            .accessibilityAddTraits(.isHeader)
        }
    }

    private struct TagChip: View {
        var label: String
        var systemImage: String
        var body: some View {
            Label(label, systemImage: systemImage)
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.35)))
        }
    }

    private struct EduRow: View {
        var title: String
        var subtitle: String
        var icon: String
        var body: some View {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(colors: [.skyPop.opacity(0.7), .grape.opacity(0.7)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                        .font(.subheadline.bold())
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.subheadline.bold())
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
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

    // Un pequeño efecto festivo para el botón "Descargar CV"
    private struct ConfettiBurst: View {
        @State private var animate = false
        var body: some View {
            ZStack {
                ForEach(0..<10) { i in
                    Circle()
                        .fill([Color.sunny, .bubblePink, .neonMint, .skyPop, .grape].randomElement()!.opacity(0.9))
                        .frame(width: CGFloat(Int.random(in: 6...10)),
                               height: CGFloat(Int.random(in: 6...10)))
                        .offset(x: animate ? CGFloat.random(in: -120...20) : 0,
                                y: animate ? CGFloat.random(in: -120...20) : 0)
                        .rotationEffect(.degrees(animate ? Double.random(in: 0...360) : 0))
                        .animation(.interpolatingSpring(stiffness: 60, damping: 10)
                            .delay(Double(i) * 0.02), value: animate)
                }
            }
            .frame(width: 140, height: 140)
            .onAppear { animate = true }
        }
    }
}

