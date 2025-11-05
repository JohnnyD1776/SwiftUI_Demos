//
/*

  Filename: PreciseTimerDemo.swift
 Project: Demo Project


  Created by John Durcan on 05/11/2025.

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

  File Description: Demonstrate a Precise Timer
  
*/

import SwiftUI
import Combine

struct PreciseTimerDemo: View {
  @State private var currentTime = Date()
  @State private var timer: DispatchSourceTimer?
  @State private var isRunning = true
  
  private let calendar = Calendar.current
  
  var body: some View {
    ZStack {
      // Background gradient
      LinearGradient(
        colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()
      
      VStack(spacing: 40) {

        // Analog Clock
        PreciseAnalogClockView(currentTime: currentTime)
          .frame(width: 250, height: 250)
          .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        
        // Digital Clock
        DigitalClockView(currentTime: currentTime)
          .font(.system(size: 48, weight: .light, design: .monospaced))
          .foregroundColor(.primary)
          .padding()
          .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(Color.primary.opacity(0.1), lineWidth: 1)
          )
        
        // Control Button
        Button(action: toggleTimer) {
          Label(isRunning ? "Pause" : "Resume", systemImage: isRunning ? "pause.fill" : "play.fill")
            .font(.title2.bold())
            .frame(maxWidth: .infinity)
            .padding()
            .background(isRunning ? Color.orange : Color.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding(.horizontal, 40)
      }
      .padding()
    }
    .onAppear(perform: startTimer)
    .onDisappear(perform: stopTimer)
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
      // Optional: pause when app goes to background
    }
  }
  
  // MARK: - Timer Control
  private func startTimer() {
    guard timer == nil else { return }
    
    let timer = DispatchSource.makeTimerSource(queue: .global(qos: .userInteractive))
    self.timer = timer
    
    // Sync to next full second
    let now = Date()
    let seconds = now.timeIntervalSince1970
    let nextSecond = ceil(seconds)
    let delay = max(0, nextSecond - seconds)
    
    // Initial fire after delay
    DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + delay) {
      DispatchQueue.main.async {
        self.currentTime = Date()
      }
      // Then start repeating
      timer.setEventHandler {
        DispatchQueue.main.async {
          self.currentTime = Date()
        }
      }
      
      timer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .nanoseconds(1))
      timer.activate()
    }
  }
  
  private func stopTimer() {
    timer?.cancel()
    timer = nil
  }
  
  private func toggleTimer() {
    isRunning.toggle()
    if isRunning {
      startTimer()
    } else {
      stopTimer()
    }
  }
}

// MARK: - Analog Clock View
struct PreciseAnalogClockView: View {
  let currentTime: Date
  private let calendar = Calendar.current
  
  var body: some View {
    ZStack {
      // Clock Face
      Circle()
        .fill(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
      
      // Hour Marks
      ForEach(0..<12) { hour in
        Rectangle()
          .fill(Color.primary)
          .frame(width: 4, height: hour % 3 == 0 ? 20 : 12)
          .offset(y: -110)
          .rotationEffect(.degrees(Double(hour) * 30))
      }
      
      // Hour Hand
      HandShape()
        .fill(Color.primary.opacity(0.8))
        .frame(width: 8, height: 70)
        .offset(y: -35)
        .rotationEffect(hourAngle)
      
      // Minute Hand
      HandShape()
        .fill(Color.primary)
        .frame(width: 6, height: 100)
        .offset(y: -50)
        .rotationEffect(minuteAngle)
      
      // Second Hand (Smooth!)
      HandShape()
        .fill(Color.red)
        .frame(width: 2, height: 110)
        .offset(y: -55)
        .rotationEffect(secondAngle)
        .animation(.linear(duration: 0.1), value: secondAngle) // Smooth second hand
      
      // Center Dot
      Circle()
        .fill(Color.primary)
        .frame(width: 12, height: 12)
    }
  }
  
  private var hourAngle: Angle {
    let hour = calendar.component(.hour, from: currentTime) % 12
    let minute = calendar.component(.minute, from: currentTime)
    return .degrees(Double(hour) * 30 + Double(minute) * 0.5)
  }
  
  private var minuteAngle: Angle {
    let minute = calendar.component(.minute, from: currentTime)
    let second = calendar.component(.second, from: currentTime)
    return .degrees(Double(minute) * 6 + Double(second) * 0.1)
  }
  
  private var secondAngle: Angle {
    let second = calendar.component(.second, from: currentTime)
    let nanosecond = calendar.component(.nanosecond, from: currentTime)
    let subsecond = Double(nanosecond) / 1_000_000_000
    return .degrees(Double(second) * 6 + subsecond * 6)
  }
}

// MARK: - Hand Shape
struct HandShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.width
    let height = rect.height
    
    path.move(to: CGPoint(x: width / 2, y: 0))
    path.addLine(to: CGPoint(x: width, y: height * 0.2))
    path.addLine(to: CGPoint(x: width * 0.7, y: height))
    path.addLine(to: CGPoint(x: width * 0.3, y: height))
    path.addLine(to: CGPoint(x: 0, y: height * 0.2))
    path.closeSubpath()
    return path
  }
}

// MARK: - Digital Clock View
struct DigitalClockView: View {
  let currentTime: Date
  private let formatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "HH:mm:ss"
    return f
  }()
  
  var body: some View {
    Text(formatter.string(from: currentTime))
      .font(.system(size: 48, weight: .thin, design: .monospaced))
      .tracking(2)
  }
}

// MARK: - Preview
struct PreciseTimerDemo_Previews: PreviewProvider {
  static var previews: some View {
    PreciseTimerDemo()
      .preferredColorScheme(.light)
  }
}
