/*
 
 Filename: TimelineViewDemo.swift
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
 Presents Timeline View Demos
 */

import SwiftUI

struct TimelineViewDemo: View {
  @State private var selectedDemo: DemoType = .realTimeClock
  @State private var displayedDemo: DemoType = .realTimeClock
  @State private var transitionDirection: Int = 1
  
  enum DemoType: String, CaseIterable, Identifiable {
    case realTimeClock = "Clock"
    case countdownTimer = "Countdown"
    case animatedCircle = "Circle"
    case dailyProgress = "Day of Month"
    case rainEffect = "Rain"
    case analogClock = "Analog"
    var id: Self { self }
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Picker("Select Demo", selection: $selectedDemo) {
        ForEach(DemoType.allCases) { demo in
          Text(demo.rawValue).tag(demo)
        }
      }
      .pickerStyle(.segmented)
      .padding()
      .background(Color(.systemGray6))
      
      ZStack {
        LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray5)]), startPoint: .top, endPoint: .bottom)
          .ignoresSafeArea()
        
        Group {
          switch displayedDemo {
          case .realTimeClock:
            RealTimeClockView()
          case .countdownTimer:
            CountdownTimerView(endDate: Date().addingTimeInterval(300))
          case .animatedCircle:
            AnimatedCircleView()
          case .dailyProgress:
            DailyProgressView()
          case .rainEffect:
            RainEffectView()
          case .analogClock:
            AnalogClockView()
          }
        }
        .background(
          LinearGradient(
            gradient: Gradient(colors: [.gray.opacity(0.8), .black]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .transition(.asymmetric(
          insertion: .move(edge: transitionDirection > 0 ? .trailing : .leading),
          removal: .move(edge: transitionDirection > 0 ? .leading : .trailing)
        ))
      }
    }
    .navigationTitle("TimelineView Demos")
    .navigationBarTitleDisplayMode(.inline)
    .onChange(of: selectedDemo) { oldValue, newValue in
      if oldValue == newValue { return }
      let oldIndex = DemoType.allCases.firstIndex(of: oldValue)!
      let newIndex = DemoType.allCases.firstIndex(of: newValue)!
      transitionDirection = newIndex > oldIndex ? 1 : -1
      withAnimation(.easeInOut(duration: 0.3)) {
        displayedDemo = newValue
      }
    }
  }
}

struct DailySchedule: TimelineSchedule {
  func entries(from startDate: Date, mode: Mode) -> some Sequence<Date> {
    (1...30).map { startDate.addingTimeInterval(Double($0 * 24 * 3600)) }
  }
}

extension TimelineSchedule where Self == DailySchedule {
  static var daily: Self { .init() }
}


#Preview {
  TimelineViewDemo()
}
