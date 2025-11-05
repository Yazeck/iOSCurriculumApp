//
//  GlassCard.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    var corner: CGFloat = 28
    var content: () -> Content
    
    init(corner: CGFloat = 28, @ViewBuilder content: @escaping () -> Content) {
        self.corner = corner
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: corner)
                    .strokeBorder(.white.opacity(0.35), lineWidth: 1)
                    .blendMode(.overlay)
            )
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
            .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 10)
    }
}
 

