//
/*

  Filename: ParallaxDemo.swift
 Project: Demo Project


  Created by John Durcan on 01/10/2025.

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
  
*/
import SwiftUI
import Combine

fileprivate struct Config {
  static let scrollSpeed: CGFloat = 1
  static let timerInterval: CGFloat = 1/60
  static let contentWidthMultiplier: CGFloat = 3
  static let verticalOffsetLandscape: CGFloat = 0.4
  static let verticalOffsetPortrait: CGFloat = 0.6
  static let sunSize: (landscape: CGFloat, portrait: CGFloat) = (60, 80)
  static let cloudSize: (landscape: CGFloat, portrait: CGFloat) = (40, 60)
  static let treeSize: (landscape: CGFloat, portrait: CGFloat) = (80, 100)
  static let houseSize: (landscape: CGFloat, portrait: CGFloat) = (60, 80)
  static let animalSize: (landscape: CGFloat, portrait: CGFloat) = (40, 50)
  static let spacing: (landscape: CGFloat, portrait: CGFloat) = (250, 200)
  static let animalSpacing: (landscape: CGFloat, portrait: CGFloat) = (150, 100)
}

struct ParallaxDemo: View {
  @State private var scrollOffset: CGFloat = 0
  @State private var isDragging: Bool = false
  @State private var dragStartOffset: CGFloat = 0
  @State private var sunGlowRadius: CGFloat = 5
  @State private var rabbitJumpOffset: CGFloat = 0
  @State private var birdFlapOffset: CGFloat = 0
  @State private var viewSize: CGSize = .zero
  @State private var timerCount: Int = 0

  private let timer = Timer.publish(every: Config.timerInterval, on: .main, in: .common).autoconnect()

  var body: some View {
    if viewSize == .zero {
      Color.clear
        .ignoresSafeArea()
        .onGeometryChange(for: CGSize.self, of: { $0.size }) { newSize in
          viewSize = newSize
        }
    } else {
      let isLandscape = viewSize.width > viewSize.height
      let contentWidth = viewSize.width * (isLandscape ? 2.5 : Config.contentWidthMultiplier)
      ZStack {
        skyBackground
        ForEach([
          (content: AnyView(backgroundView(isLandscape: isLandscape)), speed: 0.2),
          (content: AnyView(buildingsView(isLandscape: isLandscape)), speed: 0.5),
          (content: AnyView(animalsView(isLandscape: isLandscape)), speed: 0.8)
        ], id: \.speed) { layer in
          parallaxLayer(contentWidth: contentWidth, speed: layer.speed) {
            layer.content
          }
          .frame(maxHeight: .infinity, alignment: .bottom)
        }
        foregroundView
      }
      .gesture(
        dragGesture
      )
      .onReceive(timer) { _ in
        timerCount += 1
        if !isDragging {
          scrollOffset += Config.scrollSpeed
        }
        if timerCount % Int(1.5 / Config.timerInterval) == 0 {
          withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            sunGlowRadius = sunGlowRadius == 5 ? 35 : 15
          }
        }
        if timerCount % Int(2.0 / Config.timerInterval) == 0 {
          withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            rabbitJumpOffset = rabbitJumpOffset == 0 ? 20 : 0
          }
        }
        if timerCount % Int(0.8 / Config.timerInterval) == 0 {
          withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            birdFlapOffset = birdFlapOffset == 0 ? 15 : -15
          }
        }
      }
    }
  }

// MARK: Views

  var skyBackground: some View {
    LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3), .cyan.opacity(0.5), .white]), startPoint: .top, endPoint: .bottom)
      .ignoresSafeArea()
  }

  func animalsView(isLandscape: Bool) -> some View {
    HStack(spacing: isLandscape ? Config.animalSpacing.landscape : Config.animalSpacing.portrait) {
      Image(systemName: "hare.fill")
        .font(.system(size: isLandscape ? Config.animalSize.landscape : Config.animalSize.portrait))
        .foregroundStyle(.gray.gradient)
        .offset(y: (isLandscape ? -5 : -10) - rabbitJumpOffset)
      Image(systemName: "bird.fill")
        .font(.system(size: (isLandscape ? Config.animalSize.landscape : Config.animalSize.portrait) * 0.8))
        .foregroundStyle(.blue.gradient)
        .offset(y: (isLandscape ? -80 : -100) + birdFlapOffset)
      Image(systemName: "cat.fill")
        .font(.system(size: isLandscape ? Config.animalSize.landscape : Config.animalSize.portrait))
        .foregroundStyle(.brown.gradient)
        .offset(y: isLandscape ? -20 : -30)
      Image(systemName: "leaf.fill")
        .font(.system(size: (isLandscape ? Config.animalSize.landscape : Config.animalSize.portrait) * 0.6))
        .foregroundStyle(.green.gradient)
        .rotationEffect(.degrees(45))
      Image(systemName: "hare.fill")
        .font(.system(size: isLandscape ? Config.animalSize.landscape : Config.animalSize.portrait))
        .foregroundStyle(.gray.gradient)
        .offset(y: (isLandscape ? -5 : -10) - rabbitJumpOffset)
    }
  }

  func buildingsView(isLandscape: Bool) -> some View {
    HStack(spacing: (isLandscape ? Config.spacing.landscape : Config.spacing.portrait) * 0.75) {
      ForEach(0..<2) { index in
        Image(systemName: "tree.fill")
          .font(.system(size: (isLandscape ? Config.treeSize.landscape : Config.treeSize.portrait) * (CGFloat(index) * 0.1 + 1)))
          .foregroundStyle(.green.gradient)
          .offset(y: -10)
        Image(systemName: "house.fill")
          .font(.system(size: (isLandscape ? Config.houseSize.landscape : Config.houseSize.portrait) * (CGFloat(index) * 0.1 + 1)))
          .foregroundStyle(.red.gradient)
          .offset(y: 10)
      }
    }
  }

  func backgroundView(isLandscape: Bool) -> some View {
    let verticalOffset = viewSize.height * (isLandscape ? Config.verticalOffsetLandscape : Config.verticalOffsetPortrait)

    return HStack(spacing: isLandscape ? Config.spacing.landscape : Config.spacing.portrait) {
      ForEach(0..<2) { _ in
        Image(systemName: "sun.max.fill")
          .font(.system(size: isLandscape ? Config.sunSize.landscape : Config.sunSize.portrait))
          .foregroundStyle(.yellow.gradient)
          .offset(y: -verticalOffset)
          .shadow(color: .red.opacity(0.8), radius: sunGlowRadius)
        Image(systemName: "cloud.fill")
          .font(.system(size: isLandscape ? Config.cloudSize.landscape : Config.cloudSize.portrait))
          .foregroundStyle(.white.gradient)
          .offset(y: -verticalOffset * 0.8)
      }
    }
  }

  var foregroundView: some View {
    LinearGradient(gradient: Gradient(colors: [.green, .brown]), startPoint: .top, endPoint: .bottom)
      .frame(height: 50)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .ignoresSafeArea()
  }

//MARK: Helpers

  private func positiveMod(_ value: CGFloat, _ modulus: CGFloat) -> CGFloat {
    guard modulus != 0 else { return 0 }
    let r = value.truncatingRemainder(dividingBy: modulus)
    return r < 0 ? r + modulus : r
  }

  private func parallaxLayer<Content: View>(contentWidth: CGFloat, speed: CGFloat, alignment: Alignment = .bottom, @ViewBuilder content: @escaping () -> Content) -> some View {
    let shift = positiveMod(scrollOffset * speed, contentWidth)
    return HStack(spacing: 0) {
      ForEach(0..<2, id: \.self) { _ in
        content()
          .frame(width: contentWidth, alignment: alignment)
      }
    }
    .frame(width: contentWidth * 2, alignment: .leading)
    .offset(x: -shift)
    .allowsHitTesting(false)
  }

  var dragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        if !isDragging {
          isDragging = true
          dragStartOffset = scrollOffset
        }
        scrollOffset = dragStartOffset - value.translation.width
      }
      .onEnded { _ in isDragging = false }
  }
}

#Preview {
  ParallaxDemo()
}
