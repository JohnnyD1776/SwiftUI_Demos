//
/*

  Filename: VisualEffectsDemo.swift
 Project: Demo Project


  Created by John Durcan on 29/09/2025.

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

  File Description: Present Visual Effects Demo

*/

import SwiftUI

struct VisualEffectsDemo: View {
  @State private var brightnessWidth: CGFloat = 150

  private let estimatedCenterY: CGFloat = 200

  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()

      ScrollView {
        VStack(spacing: 20) {
          Spacer()
            .containerRelativeFrame(.vertical) { height, _ in height * 0.5 }

          Text("SwiftUI Visual Effects Demo")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 20)

          VStack {
            Text("Dynamic Blur Effect")
              .font(.title2)
              .foregroundColor(.white)

            ZStack {
              Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.red)

              Text("Blur by Y Position")
                .padding()
                .background(.ultraThinMaterial)
                .visualEffect { content, geometry in
                  let midY = geometry.frame(in: .global).midY
                  let distance = abs(midY - estimatedCenterY)
                  let blurRadius = max(10 - distance / 40, 0)
                  return content.blur(radius: blurRadius)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
          }
          .padding()
          .background(.black.opacity(0.2))
          .clipShape(RoundedRectangle(cornerRadius: 15))
          .containerRelativeFrame(.horizontal) { width, _ in width * 0.9 }

          VStack {
            Text("Dynamic Brightness Effect")
              .font(.title2)
              .foregroundColor(.white)

            ZStack {
              Image(systemName: "star.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.yellow)

              Text("Brightness by Size")
                .frame(width: brightnessWidth)
                .padding()
                .background(.regularMaterial)
                .visualEffect { content, geometry in
                  let width = geometry.size.width
                  let brightness = min(max(width / 300, 0.1), 1)
                  return content
                    .brightness(brightness)
                    .contrast(1.2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Slider(value: $brightnessWidth, in: 50...300) {
              Text("Adjust Width")
            }
            .padding()
          }
          .padding()
          .background(.black.opacity(0.2))
          .clipShape(RoundedRectangle(cornerRadius: 15))
          .containerRelativeFrame(.horizontal) { width, _ in width * 0.9 }

          VStack {
            Text("Dynamic Hue Rotation Effect")
              .font(.title2)
              .foregroundColor(.white)

            Rectangle()
              .fill(.pink.opacity(0.3))
              .frame(width: 150, height: 150)
              .visualEffect { content, geometry in
                let midY = geometry.frame(in: .global).midY
                let distance = abs(midY - estimatedCenterY)
                let angle = max(90 - distance / 4, 0)
                return content.hueRotation(.degrees(angle))
              }
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
          .padding()
          .background(.black.opacity(0.2))
          .clipShape(RoundedRectangle(cornerRadius: 15))
          .containerRelativeFrame(.horizontal) { width, _ in width * 0.9 }

          VStack {
            Text("Dynamic Material + Blur Effect")
              .font(.title2)
              .foregroundColor(.white)

            ZStack {
              Image(systemName: "cloud.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.cyan)

              Text("Blur by Y Position")
                .padding()
                .background(.regularMaterial)
                .visualEffect { content, geometry in
                  let midY = geometry.frame(in: .global).midY
                  let distance = abs(midY - estimatedCenterY)
                  let blurRadius = max(8 - distance / 50, 0)
                  return content.blur(radius: blurRadius)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
          }
          .padding()
          .background(.black.opacity(0.2))
          .clipShape(RoundedRectangle(cornerRadius: 15))
          .containerRelativeFrame(.horizontal) { width, _ in width * 0.9 }

          Spacer()
            .containerRelativeFrame(.vertical) { height, _ in height * 0.5 }
        }
        .padding()
      }
    }
    .scrollIndicators(.hidden)
  }
}

#Preview {
  if #available(iOS 17.0, *) {
    VisualEffectsDemo()
  } else {
    MinimumVersionView(version: 17)
  }

}


