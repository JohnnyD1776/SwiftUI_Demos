//
/*

  Filename: RadialLayoutView.swift
 Project: Demo Project


  Created by John Durcan on 27/10/2025.

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

  File Description: Presents a circular menu
  
*/

import SwiftUI

struct RadialLayout: Layout {
  var angleOffset: Double = 0.0
  
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    proposal.replacingUnspecifiedDimensions()
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    let radius = min(bounds.width, bounds.height) / 2  // Adjust as needed
    let count = Double(subviews.count)
    
    for (index, subview) in subviews.enumerated() {
      let angle = (Double(index) / count) * (2 * .pi) + angleOffset
      
      let xPos = bounds.midX + radius * cos(angle) - subview.sizeThatFits(.unspecified).width / 2
      let yPos = bounds.midY + radius * sin(angle) - subview.sizeThatFits(.unspecified).height / 2
      
      subview.place(at: CGPoint(x: xPos, y: yPos), proposal: .unspecified)
    }
  }
}

struct RotatableCircleView: View {
  @State private var items: [String] = ["star.fill", "heart.fill", "bolt.fill", "leaf.fill", "atom"]
  @State private var rotationAngle: Double = 0.0
  @State private var previousAngle: Double = 0.0
  @State private var isDragging: Bool = false
  @State private var lastSelectedIndex: Int = 0
  @State private var selectedIndex: Int = 0
  
  private let haptic = UIImpactFeedbackGenerator(style: .light)
  
  var body: some View {
    VStack {
      Spacer()
      GeometryReader { geo in
        ZStack {
          Circle().stroke(.white, lineWidth: 2)
          
          RadialLayout(angleOffset: -.pi / 2) {
            ForEach(0..<items.count, id: \.self) { index in
              iconView(index: index)
            }
          }
          .rotationEffect(.radians(rotationAngle))
        }
        .frame(width: geo.size.width, height: geo.size.height)
        .gesture(
          dragGesture(geo: geo)
        )
      }
      .frame(width: 300, height: 300)
      Spacer()
        HStack{
          Image(systemName: items[selectedIndex])
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundStyle(.blue)
          Text("Selected: \(items[selectedIndex])").padding(24)
        }
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 60, style: .continuous).fill(.white.opacity(0.5)))
        
      Spacer()
    }
    .onAppear {
      selectedIndex = closestIndex(angleOffset: rotationAngle - .pi / 2, count: items.count)
      lastSelectedIndex = selectedIndex
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
    .background(LinearGradient(colors: [.red,.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
  }
  
  // MARK: View Modifiers
  
  private func dragGesture(geo: GeometryProxy) -> some Gesture {
    DragGesture(minimumDistance: 10)
      .onChanged { value in
        let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
        let currentPos = CGPoint(x: value.location.x - center.x, y: value.location.y - center.y)
        let currentAngle = atan2(currentPos.y, currentPos.x)
        
        if !isDragging {
          isDragging = true
          previousAngle = currentAngle
          lastSelectedIndex = closestIndex(angleOffset: rotationAngle - .pi / 2, count: items.count)
          return
        }
        
        let delta = angleDifference(currentAngle, previousAngle)
        rotationAngle += delta
        previousAngle = currentAngle
        
        let newSelected = closestIndex(angleOffset: rotationAngle - .pi / 2, count: items.count)
        if newSelected != lastSelectedIndex {
          haptic.impactOccurred()
          lastSelectedIndex = newSelected
        }
        
        selectedIndex = newSelected
      }
      .onEnded { _ in
        isDragging = false
        let snappedEffective = snapAngle(current: rotationAngle - .pi / 2, count: items.count)
        withAnimation(.spring()) {
          rotationAngle = snappedEffective + .pi / 2
        }
        selectedIndex = closestIndex(angleOffset: (snappedEffective), count: items.count)
      }
  }
  
  private func iconView(index: Int) -> some View {
    let name = items[index]

    return Image(systemName: name)
      .resizable()
      .frame(width: 40, height: 40)
      .foregroundStyle(.blue)
      .padding(6)
      .background(Circle().fill(selectedIndex == index ? .white : .clear).opacity(0.4))
      .rotationEffect(.radians(-rotationAngle))
      .onTapGesture {
        let count = Double(items.count)
        let topAngle = -Double.pi / 2
        let selected = index
        let currentEffective = rotationAngle - .pi / 2
        var target = topAngle - (Double(selected) / count) * 2 * .pi
        target += 2 * .pi * round((currentEffective - target) / (2 * .pi))
        withAnimation(.spring()) {
          rotationAngle = target + .pi / 2
        }
        haptic.impactOccurred()
        selectedIndex = selected
      }
  }
  
  private func angleDifference(_ a: Double, _ b: Double) -> Double {
    var diff = (a - b).truncatingRemainder(dividingBy: 2 * .pi)
    if diff > .pi { diff -= 2 * .pi }
    if diff < -.pi { diff += 2 * .pi }
    return diff
  }
  
  private func closestIndex(angleOffset: Double, count: Int) -> Int {
    var minDiff = Double.infinity
    var closest = 0
    let topAngle = -Double.pi / 2
    
    for i in 0..<count {
      let itemAngle = ((Double(i) / Double(count)) * 2 * .pi + angleOffset).truncatingRemainder(dividingBy: 2 * .pi)
      let diff = abs(angleDifference(itemAngle, topAngle))
      if diff < minDiff {
        minDiff = diff
        closest = i
      }
    }
    return closest
  }
  
  private func snapAngle(current: Double, count: Int) -> Double {
    let selected = closestIndex(angleOffset: current, count: count)
    let topAngle = -Double.pi / 2
    var target = topAngle - (Double(selected) / Double(count)) * 2 * .pi
    target += 2 * .pi * round((current - target) / (2 * .pi))
    return target
  }
}

#Preview {
  RotatableCircleView()
}
