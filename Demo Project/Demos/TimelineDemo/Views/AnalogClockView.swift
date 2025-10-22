//
/*

  Filename: AnalogClockView.swift
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

struct AnalogClockView: View {
  private let hourHandColor = Color.gray
  private let minuteHandColor = Color.black
  private let secondHandColor = Color.red
  
  var body: some View {
    TimelineView(.animation(minimumInterval: 1 / 60)) { context in
      let components = Calendar.current.dateComponents([.hour, .minute, .second], from: context.date)
      let hour = Double(components.hour ?? 0)
      let minute = Double(components.minute ?? 0)
      let second = Double(components.second ?? 0)
      
      let hourAngle = (hour * 30) + (minute * 0.5)
      let minuteAngle = (minute * 6) + (second * 0.1)
      let secondAngle = second * 6
      
      VStack(spacing: 16) {
        Text("Analog Clock")
          .font(.system(size: 24, weight: .semibold, design: .rounded))
          .foregroundColor(.white)
        
        ZStack {
          // Clock face
          Circle()
            .fill(Color.white)
            .frame(width: 200, height: 200)
            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
          
          // Rim
          Circle()
            .stroke(Color.gray, lineWidth: 2)
            .frame(width: 200, height: 200)
          
          // Minute markers (ticks)
          ForEach(0..<60) { tick in
            let isMajor = tick % 5 == 0
            let height: CGFloat = isMajor ? 12 : 5
            let width: CGFloat = isMajor ? 2 : 1
            let radius: CGFloat = 95
            
            Rectangle()
              .fill(Color.gray)
              .frame(width: width, height: height)
              .offset(y: -(radius - height / 2))
              .rotationEffect(.degrees(Double(tick) * 6))
          }
          
          // Hour markers
          ForEach(0..<12) { hour in
            Text("\(hour == 0 ? 12 : hour)")
              .font(.system(size: 16, weight: .medium))
              .position(x: 100, y: 100)
              .offset(x: 70 * cos(CGFloat(hour) * .pi / 6 - .pi / 2),
                      y: 70 * sin(CGFloat(hour) * .pi / 6 - .pi / 2))
          }
          
          // Hour hand
          Capsule()
            .fill(hourHandColor)
            .frame(width: 6, height: 50)
            .offset(y: -25)
            .rotationEffect(.degrees(hourAngle))
            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
          
          // Minute hand
          Capsule()
            .fill(minuteHandColor)
            .frame(width: 4, height: 70)
            .offset(y: -35)
            .rotationEffect(.degrees(minuteAngle))
            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
          
          // Second hand
          Capsule()
            .fill(secondHandColor)
            .frame(width: 2, height: 80)
            .offset(y: -40)
            .rotationEffect(.degrees(secondAngle))
            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
          
          // Center pin
          Circle()
            .fill(Color.black)
            .frame(width: 8, height: 8)
        }
        .frame(width: 200, height: 200)
        .overlay(
          Group {
            if #available(iOS 26.0, *) {
              Circle()
                .glassEffect(.clear, in: .circle)
                .opacity(0.9)
            } else {
              Circle()
                .fill(
                  RadialGradient(
                    gradient: Gradient(colors: [.white.opacity(0.4), .clear]),
                    center: UnitPoint(x: 0.25, y: 0.25),
                    startRadius: 0,
                    endRadius: 150
                  )
                )
                .blendMode(.overlay)
            }
          }
        )
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
