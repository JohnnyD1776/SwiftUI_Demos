//
/*

  Filename: SFSymbolAnimates.swift
 Project: Demo Project


  Created by John Durcan on 18/11/2025.

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

  File Description: Demo SFSymbols with Values
  
*/

import SwiftUI

struct SFSymbolsDemoView: View {
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 40) {
          SymbolDemo(symbolName: "speaker.wave.3.fill", description: "Volume level")
          SymbolDemo(symbolName: "wifi", description: "Wi-Fi signal strength")
          SymbolDemo(symbolName: "cellularbars", description: "Cellular signal strength")
          SymbolDemo(symbolName: "chart.bar.fill", description: "Bar chart fill progress")
          SymbolDemo(symbolName: "waveform", description: "Audio waveform intensity")
          if #available(iOS 26.0, *) {
            SymbolDemo(symbolName: "thermometer.high", description: "Thermometer level")
          }
        }
        .padding()
      }
      .navigationTitle("SF Symbol Variables")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

struct SymbolDemo: View {
  let symbolName: String
  let description: String
  @State private var value: Double = 0.5
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(description)
        .font(.headline)
      
      HStack {
        if symbolName == "thermometer.high" {
          thermometerImage
        } else {
          Image(systemName: symbolName, variableValue: value)
            .symbolRenderingMode(.multicolor)
            .font(.system(size: 100))
            .foregroundStyle(.blue)
        }
        Spacer()
      }
      
      Slider(value: $value, in: 0...1)
        .accentColor(.blue)
      
      Button("Animate Change") {
        withAnimation(.linear(duration: 3.0)) {
          value = value >= 0.5 ? 0.1 : 0.9
        }
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
    .cornerRadius(10)
  }
  
  @ViewBuilder
  private var thermometerImage: some View {
    Image(systemName: symbolName, variableValue: value)
      .symbolRenderingMode(.multicolor)
      .font(.system(size: 100))
      .foregroundStyle(.blue)
      .applyVariableValueModeIfAvailable()
  }
}

extension View {
  @ViewBuilder
  func applyVariableValueModeIfAvailable() -> some View {
    if #available(iOS 26.0, *) {
      self.symbolVariableValueMode(.draw)
    } else {
      self
    }
  }
}

#Preview {
  SFSymbolsDemoView()
}
