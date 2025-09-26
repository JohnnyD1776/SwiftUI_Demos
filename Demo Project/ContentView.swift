//
//  ContentView.swift
//  Demo Project
//
//  Created by John Durcan on 26/09/2025.
//

import SwiftUI

enum Demo: String, CaseIterable, Identifiable, Hashable {
    case geometry
    case morphingStar
    case transitions

    var id: Self { self }

    var title: String {
        switch self {
        case .geometry: return "Geometry Demo"
        case .morphingStar: return "Morphing Star"
        case .transitions: return "Transition Demos"
        }
    }

    var systemImage: String {
        switch self {
        case .geometry: return "rectangle.3.group.bubble.left"
        case .morphingStar: return "star.circle"
        case .transitions: return "sparkles"
        }
    }

    @ViewBuilder
    func destinationView() -> some View {
        switch self {
        case .geometry:
            GeometryDemoView()
        case .morphingStar:
            MorphingStarView()
        case .transitions:
            TransitionGallery() // Your "TransitionDemos" view is named TransitionGallery
        }
    }
}

struct ContentView: View {
    @State private var selectedDemo: Demo? = .geometry

    var body: some View {
        NavigationSplitView {
            List(Demo.allCases, selection: $selectedDemo) { demo in
                Label(demo.title, systemImage: demo.systemImage)
                    .tag(demo)
            }
            .navigationTitle("Demos")
        } detail: {
            if let demo = selectedDemo {
                demo.destinationView()
                    .navigationTitle(demo.title)
            } else {
                Text("Select a demo")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContentView()
}
