//
/*

  Filename: CustomArcProgress.swift
 Project: Demo Project


  Created by John Durcan on 30/09/2025.

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

  File Description: Demonstrate Custom Arc Progress

*/
import SwiftUI

struct CustomArcProgress: View {
  @State private var progress: CGFloat = 0.0
  @State private var isTimerRunning: Bool = false
  @State private var timer: Timer?

  // Completion presentation states
  @State private var showCompletion: Bool = false
  @State private var pulse: Bool = false
  @State private var hideIndicator: Bool = true

  // Tuning
  private let ringSize: CGFloat = 180
  private let lineWidth: CGFloat = 12
  private let totalDuration: TimeInterval = 5.0
  private let tick: TimeInterval = 1.0 / 60.0

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [
          Color(.sRGB, red: 0.10, green: 0.12, blue: 0.20, opacity: 1.0),
          Color(.sRGB, red: 0.07, green: 0.08, blue: 0.14, opacity: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack(spacing: 24) {
        ZStack {
          Circle()
            .strokeBorder(Color.white.opacity(showCompletion ? 0.25 : 0.10), lineWidth: lineWidth)
            .frame(width: ringSize + 18, height: ringSize + 18)
            .scaleEffect(showCompletion ? (pulse ? 1.06 : 0.98) : 1.0)
            .animation(showCompletion ? .easeInOut(duration: 1.1).repeatForever(autoreverses: true) : .default, value: pulse)

          ArcProgressShape(progress: 1.0)
            .stroke(Color.white.opacity(0.15), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: ringSize, height: ringSize)

          let progressGradient = AngularGradient(
            gradient: Gradient(colors: [
              Color.blue, Color.cyan, Color.mint, Color.teal, Color.indigo, Color.purple
            ]),
            center: .center,
            startAngle: .degrees(-90),
            endAngle: .degrees(270)
          )

          ArcProgressShape(progress: progress)
            .stroke(progressGradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: ringSize, height: ringSize)
            .shadow(color: Color.cyan.opacity(min(0.6, Double(progress) + 0.1)), radius: 8, x: 0, y: 0)

          GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = size / 2
            let angle = Angle(degrees: -90 + 360 * Double(progress)).radians
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius

            Circle()
              .fill(Color.white.opacity(0.9))
              .frame(width: lineWidth * 0.7, height: lineWidth * 0.7)
              .overlay(
                Circle()
                  .fill(Color.cyan.opacity(0.6))
                  .blur(radius: 2)
              )
              .position(x: x, y: y)
              .opacity(progress > 0 && progress < 1.0 && !hideIndicator ? 1 : 0)
          }
          .frame(width: ringSize, height: ringSize)

          VStack(spacing: 8) {
            if showCompletion {
              HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                  .foregroundStyle(.green)
                  .font(.system(size: 26, weight: .semibold))
                  .symbolRenderingMode(.hierarchical)

                Text("Complete!")
                  .font(.title2).bold()
                  .foregroundStyle(.green)
              }
              .transition(.scale.combined(with: .opacity))
              .shadow(color: .green.opacity(0.5), radius: 6)
            } else {
              Text("\(Int(progress * 100))%")
                .font(.title2).bold()
                .foregroundStyle(.white)
                .monospacedDigit()
                .transition(.opacity)
            }
          }
          .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showCompletion)
        }

        Button(action: {
          isTimerRunning.toggle()
          if isTimerRunning {
            startTimer()
          } else {
            stopTimer()
          }
        }) {
          Text(isTimerRunning ? "Pause" : (progress == 0 ? "Start" : "Resume"))
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
              LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal)

        Button(action: {
          resetProgress()
        }) {
          Text("Reset")
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
              LinearGradient(colors: [Color.red, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .red.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal)
      }
      .padding()
    }
    .onChange(of: progress) { newValue in
      if newValue >= 1.0 && !showCompletion {
        showCompletion = true
        pulse = true
        stopTimer()
        notifyCompletionHaptic()
      }
    }
    .onDisappear {
      stopTimer()
    }
  }

  @MainActor
  private func startTimer() {
    timer?.invalidate()
    timer = nil

    let increment = CGFloat(tick / totalDuration)
    isTimerRunning = true
    hideIndicator = false

    timer = Timer.scheduledTimer(withTimeInterval: tick, repeats: true) { _ in
      Task { @MainActor in
        if progress < 1.0 {
          withAnimation(.easeInOut(duration: 0.15)) {
            progress = min(1.0, progress + increment)
          }
        } else {
          stopTimer()
        }
      }
    }
  }

  @MainActor
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
    isTimerRunning = false
  }

  @MainActor
  private func resetProgress() {
    stopTimer()
    hideIndicator = true
    withAnimation(.easeInOut(duration: 0.5)) {
      progress = 0.0
      showCompletion = false
      pulse = false
    }
  }

  @MainActor
  private func notifyCompletionHaptic() {
    #if canImport(UIKit)
    UINotificationFeedbackGenerator().notificationOccurred(.success)
    #endif
  }
}

struct ArcProgressShape: Shape {
  var progress: CGFloat

  var animatableData: CGFloat {
    get { progress }
    set { progress = newValue }
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2

    path.addArc(
      center: center,
      radius: radius,
      startAngle: .degrees(-90),
      endAngle: .degrees(-90 + 360 * Double(progress)),
      clockwise: false
    )
    return path
  }
}

#Preview {
  CustomArcProgress()
}
