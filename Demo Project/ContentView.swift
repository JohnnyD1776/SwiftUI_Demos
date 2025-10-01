/*

 Filename: ContentView.swift
 Project: Demo Project


 Created by John Durcan on 26/09/2025.

 Copyright © 2025 Itch Studio Ltd.. All rights reserved.

 Company No. 14729010. Registered Address: 128, City Road, London, EC1V 2NX

 Licensed under the MIT License. You may obtain a copy of the License at

 https:opensource.org/licenses/MIT

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 👋 Welcome to my SwiftUI demo showcasing advanced animation and layout techniques!
 I'm John Durcan, a seasoned iOS and Mac App Developer passionate about creating intuitive and engaging apps.
 🌐 Connect with me on LinkedIn: http:linkedin.com/in/john-durcan
 🌟 Check out my portfolio at: https:itch.studio
 📱 Explore my AI-powered poetry app: https:poeticai.info
 💻 View more of my work on GitHub: https:github.com/JohnnyD1776
 ☕ Support my development journey: https:ko-fi.com/JohnnyD1776

 File Description:
 Presents demonstations for Transitions
 */

import SwiftUI

enum Demo: String, CaseIterable, Identifiable, Hashable {
    case geometry
    case morphingStar
    case transitions
    case customArcProgress
    case parallaxDemo

    var id: Self { self }

    var title: String {
        switch self {
        case .geometry: return "Geometry Demo"
        case .morphingStar: return "Morphing Star"
        case .transitions: return "Transition Demos"
        case .customArcProgress: return "Custom Arc Progress"
        case .parallaxDemo: return "Parallax Demo"
        }
    }

    var systemImage: String {
        switch self {
        case .geometry: return "rectangle.3.group.bubble.left"
        case .morphingStar: return "star.circle"
        case .transitions: return "sparkles"
        case .customArcProgress: return "circle.dashed"
        case .parallaxDemo: return "house"
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
        case .customArcProgress:
          CustomArcProgress()
        case .parallaxDemo:
          ParallaxDemo()
        }
    }
}

struct ContentView: View {
    @State private var selectedDemo: Demo? = nil

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

