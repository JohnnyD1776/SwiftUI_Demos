//
/*

  Filename: DailyProgressView.swift
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

struct DailyProgressView: View {
  private let strokeGradient = LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
  
  var body: some View {
    TimelineView(.daily) { context in
      VStack(spacing: 16) {
        Text("Month Progress Circle")
          .font(.system(size: 24, weight: .semibold, design: .rounded))
          .foregroundColor(.white)

        ZStack {
          Circle()
            .stroke(Color.gray.opacity(0.2), lineWidth: 12)
            .frame(width: 220, height: 220)
          
          Circle()
            .trim(from: 0, to: dayValue(for: context.date))
            .stroke(strokeGradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
            .frame(width: 220, height: 220)
            .rotationEffect(.degrees(-90))
            .shadow(color: .orange.opacity(0.5), radius: 8, x: 0, y: 0)
          
          Text("\(Calendar.current.component(.day, from: context.date))")
            .font(.system(size: 64, weight: .bold, design: .monospaced))
            .monospacedDigit()
            .foregroundColor(.orange)
          
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  private func dayValue(for date: Date) -> Double {
    Double(Calendar.current.component(.day, from: date)) / 30
  }
}
