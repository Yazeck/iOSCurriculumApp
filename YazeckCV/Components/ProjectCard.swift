//
//  ProjectCard.swift
//  YazeckCV
//
//  Created by Erick Nungaray on 04/11/25.
//

import SwiftUI

struct ProjectCard<Content: View>: View {
    var title: String
    var subtitle: String
    var icon: String
    @ViewBuilder var content: Content
    
    var body: some View {
        GlassCard {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(colors: [.sunny, .bubblePink], startPoint: .top, endPoint: .bottom))
                        .frame(width: 56, height: 56)
                        .opacity(0.7)
                    Image(systemName: icon).font(.headline).foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(title).font(.headline)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                    content
                        .font(.subheadline)
                        .padding(.top, 4)
                }
                Spacer()
            }
        }
    }
}
