//
/*

  Filename: RainEffectView.swift
 Project: Demo Project


  Created by John Durcan on 22/10/2025.

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

struct Raindrop: Hashable {
  var x: Double
  var removalDate: Date
  var speed: Double
}

class Storm: ObservableObject {
  @Published var drops = Set<Raindrop>()
  
  func update(to date: Date) {
    drops = drops.filter { $0.removalDate > date }
    if drops.count < 50 { // Limit drops for performance
      drops.insert(Raindrop(x: Double.random(in: 0...1), removalDate: date + Double.random(in: 0.5...2.0), speed: Double.random(in: 1...3)))
    }
  }
}

struct RainEffectView: View {
  @StateObject private var storm = Storm()
  let rainColor = Color(red: 0.25, green: 0.5, blue: 0.75).opacity(0.8)
  @State private var isAnimating = false
  
  var body: some View {
    VStack(spacing: 16) {
      Text("Timeline Rain Effect")
        .font(.system(size: 24, weight: .semibold, design: .rounded))
        .foregroundColor(.white)
        .padding(.top)
      
      TimelineView(.animation) { timeline in
        Canvas { context, size in
          for drop in storm.drops {
            if drop.removalDate > timeline.date {
              let age = drop.removalDate.timeIntervalSince(timeline.date)
              let y = size.height - (size.height * age * drop.speed)
              let rect = CGRect(x: drop.x * size.width, y: y, width: 2, height: 20)
              let shape = Capsule().path(in: rect)
              context.fill(shape, with: .color(rainColor))
            }
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.black]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black.opacity(0.5))
    .onAppear {
      isAnimating = true
    }
    .onDisappear {
      isAnimating = false
    }
    .task(id: isAnimating) {
      guard isAnimating else { return }
      while !Task.isCancelled {
        storm.update(to: Date())
        try? await Task.sleep(nanoseconds: 16_666_667) // ~60 FPS
      }
    }
  }
}
