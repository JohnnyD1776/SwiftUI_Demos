/*

 Filename: TransitionDemos.swift
 Project: Demo Project


 Created by John Durcan on 02/09/2025.

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

struct TransitionGallery: View {
  @State private var show = false
  @State private var selectedTransition = 0
  @State private var selectedAnimation = 0

  let transitions: [(String, AnyTransition)] = [
    ("Identity", .identity),
    ("Opacity", .opacity),
    ("Scale", .scale),
    ("Slide", .slide),
    ("Move (Leading)", .move(edge: .leading)),
    ("Move (Trailing)", .move(edge: .trailing)),
    ("Move (Top)", .move(edge: .top)),
    ("Move (Bottom)", .move(edge: .bottom)),
    ("Push (Leading)", .push(from: .leading)),
    ("Push (Trailing)", .push(from: .trailing)),
    ("Push (Top)", .push(from: .top)),
    ("Push (Bottom)", .push(from: .bottom)),
    ("Opacity + Scale", .opacity.combined(with: .scale)),
    ("Move + Opacity", .move(edge: .leading).combined(with: .opacity)),
    ("Rotate + Fade", .rotateAndFade),
    ("Blur + Scale", .blurAndScale)
  ]

  let animations: [(String, Animation)] = [
    ("EaseInOut", .easeInOut(duration: 0.6)),
    ("EaseIn", .easeIn(duration: 0.6)),
    ("EaseOut", .easeOut(duration: 0.6)),
    ("Linear", .linear(duration: 0.6)),
    ("Spring", .spring(response: 0.6, dampingFraction: 0.7)),
    ("Bouncy Curve", .timingCurve(0.68, -0.55, 0.27, 1.55, duration: 1.0))
  ]

  var body: some View {
    VStack(spacing: 20) {
      VStack {
        ZStack {
          if show {
            RoundedRectangle(cornerRadius: 16)
              .fill(Color.blue.gradient)
              .frame(width: 200, height: 120)
              .transition(transitions[selectedTransition].1)
          }
        }
        .animation(animations[selectedAnimation].1, value: show)
      }
      .frame(height: 220)
      VStack {
        Text("\(transitions[selectedTransition].0) + \(animations[selectedAnimation].0)")
          .font(.headline)

        Button(show ? "Hide" : "Show") {
          show.toggle()
        }
        .buttonStyle(.borderedProminent)
        // 🔹 Scrollable Grids
        ScrollView {
          Text("Transitions")
            .font(.title3).bold()
            .frame(maxWidth: .infinity, alignment: .leading)

          LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            ForEach(0..<transitions.count, id: \.self) { i in
              Text(transitions[i].0)
                .font(.caption)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(selectedTransition == i ? Color.blue.opacity(0.3) : Color.gray.opacity(0.15))
                .cornerRadius(8)
                .onTapGesture { selectedTransition = i }
            }
          }
          .padding(.bottom, 16)

          Text("Animations")
            .font(.title3).bold()
            .frame(maxWidth: .infinity, alignment: .leading)

          LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            ForEach(0..<animations.count, id: \.self) { i in
              Text(animations[i].0)
                .font(.caption)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(selectedAnimation == i ? Color.green.opacity(0.3) : Color.gray.opacity(0.15))
                .cornerRadius(8)
                .onTapGesture { selectedAnimation = i }
            }
          }
        }
        .padding(.horizontal)
      }
    }
    .padding()
  }
}

extension AnyTransition {
  static var rotateAndFade: AnyTransition {
    .modifier(
      active: RotateAndFadeModifier(angle: 90, opacity: 0),
      identity: RotateAndFadeModifier(angle: 0, opacity: 1)
    )
  }

  static var blurAndScale: AnyTransition {
    .modifier(
      active: BlurAndScaleModifier(blur: 10, scale: 0.3),
      identity: BlurAndScaleModifier(blur: 0, scale: 1)
    )
  }
}

// MARK: - Custom Modifiers
struct RotateAndFadeModifier: ViewModifier {
  var angle: Double
  var opacity: Double

  func body(content: Content) -> some View {
    content
      .rotationEffect(.degrees(angle))
      .opacity(opacity)
  }
}

struct BlurAndScaleModifier: ViewModifier {
  var blur: CGFloat
  var scale: CGFloat

  func body(content: Content) -> some View {
    content
      .blur(radius: blur)
      .scaleEffect(scale)
  }
}


#Preview {
  TransitionGallery()
}
