//
/*

  Filename: TextMetalRevealEffect.swift
 Project: Demo Project


  Created by John Durcan on 05/01/2026.

  Copyright © 2026 Itch Studio Ltd.. All rights reserved.

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

*/

import SwiftUI

// Custom Renderer with Animation
struct RevealEffectRenderer: TextRenderer, Animatable {
  var elapsedTime: TimeInterval
  var elementDuration: TimeInterval = 0.8  // Slower, more "liquid" feel
  var totalDuration: TimeInterval

  var animatableData: Double {
    get { elapsedTime }
    set { elapsedTime = newValue }
  }

  func draw(layout: Text.Layout, in context: inout GraphicsContext) {
    let allSlices = layout.flatMap { $0 }.flatMap { $0 }
    let totalCount = allSlices.count

    // Distribute delay to fit total duration
    let delayPerItem = totalCount > 0 ? (totalDuration - elementDuration) / Double(totalCount) : 0

    for (index, slice) in allSlices.enumerated() {
      let delay = Double(index) * delayPerItem
      let timeForThisElement = max(0, min(elapsedTime - delay, elementDuration))

      if elapsedTime > delay {
        var copy = context
        draw(slice, at: timeForThisElement, in: &copy)
      }
    }
  }

  private func draw(
    _ slice: Text.Layout.RunSlice, at time: TimeInterval, in context: inout GraphicsContext
  ) {
    let progress = time / elementDuration

    // Clamp 0...1
    let t = min(max(progress, 0), 1)

    // Animation Curves
    let easePos = 1.0 - pow(1.0 - t, 4.0)  // Quartic ease out
    let easeOpacity = t * t  // EaseIn

    // Motion Config
    // User Request: "from above left" -> Start Negative X, Negative Y
    // "Rotating" -> Start rotated

    let startX = -15.0
    let startY = -20.0  // Start above (negative Y in translation terms usually relative to baseline)
    let startRot = -25.0  // Degrees (tilted left)

    let xOffset = startX * (1.0 - easePos)
    let yOffset = startY * (1.0 - easePos)
    let rotation = startRot * (1.0 - easePos)

    let blurAmount = 6.0 * (1.0 - easePos)
    let opacity = min(1.0, easeOpacity * 2.0)

    // Chromatic Aberration Config
    // "More pronounced on presentation" -> Increase split
    let splitStart = 8.0
    let split = splitStart * (1.0 - easePos)

    // Transformation Stack
    context.translateBy(x: xOffset, y: yOffset)
    // Rotation naturally applies around the context origin (which is the glyph origin here)
    // To rotate "swinging in" from top-left, a negative rotation works well.
    context.rotate(by: .degrees(rotation))

    context.opacity = opacity

    // If fully settled, draw normally to ensure crisp text
    if t >= 0.99 {
      context.draw(slice, options: .disablesSubpixelQuantization)
      return
    }

    // Draw Chromatic Channels
    // Red (Left/Up)
    var redCtx = context
    redCtx.addFilter(.blur(radius: blurAmount))
    redCtx.translateBy(x: -split, y: -split * 0.5)
    redCtx.addFilter(.colorMultiply(Color(red: 1, green: 0, blue: 0)))
    redCtx.blendMode = .plusLighter
    redCtx.draw(slice, options: .disablesSubpixelQuantization)

    // Green (Center)
    var greenCtx = context
    greenCtx.addFilter(.blur(radius: blurAmount))
    greenCtx.addFilter(.colorMultiply(Color(red: 0, green: 1, blue: 0)))
    greenCtx.blendMode = .plusLighter
    greenCtx.draw(slice, options: .disablesSubpixelQuantization)

    // Blue (Right/Down)
    var blueCtx = context
    blueCtx.addFilter(.blur(radius: blurAmount))
    blueCtx.translateBy(x: split, y: split * 0.5)
    blueCtx.addFilter(.colorMultiply(Color(red: 0, green: 0, blue: 1)))
    blueCtx.blendMode = .plusLighter
    blueCtx.draw(slice, options: .disablesSubpixelQuantization)

    // Bloom
    if t > 0.05 && t < 0.6 {
      var bloomCtx = context
      bloomCtx.addFilter(.blur(radius: 5))
      bloomCtx.blendMode = .plusLighter
      bloomCtx.opacity = 0.6 * (1.0 - easePos)
      bloomCtx.draw(slice, options: .disablesSubpixelQuantization)
    }
  }
}

// Usage in View
struct TextMetalRevealEffectView: View {
  @State private var progress: Double = 0.0
  @State private var isPlaying: Bool = false

  // Constants
  let totalDuration: TimeInterval = 3.0

  // The text to display
  let textToReveal =
    "And blood-black nothingness began to spin. A system of cells interlinked within cells interlinked within cells interlinked within one stem. And dreadfully distinct against the dark, a tall white fountain played."


  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      VStack(spacing: 40) {
        Spacer()

        // Text View driven by the renderer directly
        Text(textToReveal)
          .font(.custom("Times New Roman", size: 30))
          .fontWeight(.medium)
          .foregroundStyle(.white)
          .multilineTextAlignment(.center)
          .frame(maxWidth: 600)
          // Drive the renderer with the current progress
          .textRenderer(
            RevealEffectRenderer(
              elapsedTime: progress * totalDuration,
              totalDuration: totalDuration
            ))

        Spacer()

        // Controls
        VStack(spacing: 20) {
          // Slider for manual scrubbing
          // We use a custom binding to stop auto-play if the user interacts
          Slider(
            value: Binding(
              get: { progress },
              set: {
                progress = $0
                // Stop playing if user scrubs
                isPlaying = false
              }
            ), in: 0...1
          )
          .tint(.white)
          .padding(.horizontal, 40)

          Text("Progress: \(Int(progress * 100))%")
            .font(.caption)
            .foregroundStyle(.gray)

          Button(action: {
            togglePlay()
          }) {
            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
              .font(.system(size: 60))
              .foregroundStyle(.white)
              .contentTransition(.symbolEffect(.replace))
          }
        }
        .padding(.bottom, 50)
      }
      .padding()
    }
  }

  private func togglePlay() {
    if isPlaying {
      // Pause
      isPlaying = false
      // The animation stops here, progress stays at current value
    } else {
      // Play
      isPlaying = true

      // If we are at the end, restart
      if progress >= 1.0 {
        progress = 0.0
      }

      // Calculate remaining time based on current progress
      let remainingTime = totalDuration * (1.0 - progress)

      withAnimation(.linear(duration: remainingTime)) {
        progress = 1.0
      } completion: {
        isPlaying = false
      }
    }
  }
}

#Preview {
  TextMetalRevealEffectView()
}
