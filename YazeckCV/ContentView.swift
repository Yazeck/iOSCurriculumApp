
//
//  ContentView.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        // Hacer TODA la interfaz transparente
        UITabBar.appearance().isTranslucent = true
        UINavigationBar.appearance().isTranslucent = true
        
        // TabBar transparente
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithTransparentBackground()
        tabAppearance.backgroundColor = .clear
        UITabBar.appearance().standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
        
        // NavigationBar transparente
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        
        // CLAVE: Quitar el fondo de las vistas de scroll
        UIScrollView.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            // Fondo líquido con burbujas
            LiquidBackground()
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            // Contenido principal
            TabBarRouter()
        }
    }
}

struct TabBarRouter: View {
    var body: some View {
        TabView {
            NavigationStack {
                InicioView()
            }
            .tabItem { Label("Inicio", systemImage: "sparkles") }
            
            NavigationStack {
                PerfilView()
            }
            .tabItem { Label("Perfil", systemImage: "person.crop.circle") }
            
            NavigationStack {
                HabilidadesView()
            }
            .tabItem { Label("Skills", systemImage: "wand.and.stars") }
            
            NavigationStack {
                ProyectosView()
            }
            .tabItem { Label("Proyectos", systemImage: "hammer") }
            
            NavigationStack {
                ContactoView()
            }
            .tabItem { Label("Contacto", systemImage: "paperplane") }
        }
        .tint(.grape)
        .background(Color.clear)  // ← CLAVE
    }
}

#Preview {
    ContentView()
}
