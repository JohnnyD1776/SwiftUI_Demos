/*

 Filename: MorphingStarView.swift
 Project: Demo Project


 Created by John Durcan on 24/09/2025.

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
Presents Morphing Shape demo
 */

import SwiftUI

// MARK: - MorphingStar Shape
// Animates from a regular n-point star (morph = 0) to a perfect circle (morph = 1)
// by blending each vertex radius toward the outer radius.
struct MorphingStar: Shape {
  var points: Int = 5
  var innerRadiusRatio: CGFloat = 0.45 // 0 < ratio < 1
  var morph: CGFloat // 0 = star, 1 = circle

  var animatableData: CGFloat {
    get { morph }
    set { morph = newValue }
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let outerR = min(rect.width, rect.height) / 2
    let steps = max(2, points) * 2
    var first = true

    for i in 0..<steps {
      // Even indices = outer points, odd = inner points
      let angle = (Double(i) * .pi / Double(points)) - .pi / 2 // start at top
      let base = (i % 2 == 0) ? 1.0 : Double(innerRadiusRatio)

      // Blend each vertex radius from star radius -> circle radius (outerR)
      let blended = (1.0 - Double(morph)) * base + Double(morph) * 1.0
      let r = outerR * CGFloat(blended)

      let x = center.x + r * CGFloat(cos(angle))
      let y = center.y + r * CGFloat(sin(angle))
      let pt = CGPoint(x: x, y: y)

      if first {
        path.move(to: pt)
        first = false
      } else {
        path.addLine(to: pt)
      }
    }

    path.closeSubpath()
    return path
  }
}

// MARK: - In-place morph demo (true path morph)
struct MorphingStarView: View {
  @State private var morph: CGFloat = 0 // 0 = star, 1 = circle
  @Namespace private var ns // Optional: attach matchedGeometry if you later add a second location

  var body: some View {
    VStack(spacing: 24) {
      Text("Star ↔ Circle (in-place morph)")
        .font(.headline)

      MorphingStar(points: 5, innerRadiusRatio: 0.45, morph: morph)
        .fill(.blue)
        .frame(width: 160, height: 160)
        .matchedGeometryEffect(id: "shape", in: ns) // harmless here; morphing comes from animatableData
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: morph)

      // Controls
      HStack(spacing: 12) {
        Button("Star") {
          withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { morph = 0 }
        }
        Button("Toggle") {
          withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { morph = morph < 0.5 ? 1 : 0 }
        }
        Button("Circle") {
          withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { morph = 1 }
        }
      }

      VStack(spacing: 8) {
        Slider(value: $morph, in: 0...1)
        Text(String(format: "Morph: %.2f (0 = star, 1 = circle)", morph))
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      .padding(.horizontal)
    }
    .padding()
  }
}

#Preview {
  MorphingStarView()
    .preferredColorScheme(.dark)
}
