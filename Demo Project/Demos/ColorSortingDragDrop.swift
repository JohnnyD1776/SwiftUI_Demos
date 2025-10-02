/*
 
 Filename: ColorSortingDragDrop.swift
 Project: Demo Project
 
 
 Created by John Durcan on 02/10/2025.
 
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
 Demo Drag and Drop


 Note: Add the following to your project PList:

 <dict>
 <key>UTExportedTypeDeclarations</key>
 <array>
 <dict>
 <key>UTTypeIdentifier</key>
 <string>YOUR_TLD_IDENTIFIER.circleData</string>
 <key>UTTypeDescription</key>
 <string>Circle Data</string>
 <key>UTTypeConformsTo</key>
 <array>
 <string>public.data</string>
 </array>
 <key>UTTypeTagSpecification</key>
 <dict>
 <key>public.mime-type</key>
 <string>application/x-studio-itch-circledata</string>
 </dict>
 </dict>
 </array>
 </dict>
 */

import SwiftUI
import UniformTypeIdentifiers

struct CircleData: Codable, Identifiable, Transferable {
  let id: UUID

  static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation(contentType: .circleData)
  }
}

extension UTType {
  static let circleData = UTType(exportedAs: "studio.itch.circleData")
}

struct ColorSortingDragDrop: View {
  @State private var circles: [(id: UUID, color: Color, position: CGPoint)] = []
  @State private var bins: [Color] = []
  @State private var feedbackMessage = "Long Press to Drag&Drop Circle to Bin"
  @State private var shake = false

  private let availableColors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]

  init() {
    _circles = State(initialValue: generateInitialCircles())
    _bins = State(initialValue: generateInitialBins())
  }

  private func generateInitialCircles() -> [(id: UUID, color: Color, position: CGPoint)] {
    let colors = Array(availableColors.shuffled().prefix(3))
    return [
      (id: UUID(), color: colors[0], position: CGPoint(x: -150, y: 0)),
      (id: UUID(), color: colors[1], position: CGPoint(x: 0, y: 0)),
      (id: UUID(), color: colors[2], position: CGPoint(x: 150, y: 0))
    ]
  }

  private func generateInitialBins() -> [Color] {
    let circleColors = circles.map { $0.color }
    return circleColors.shuffled()
  }

  private func resetGame() {
    circles = generateInitialCircles()
    bins = generateInitialBins()
    feedbackMessage = "Long Press to Drag&Drop Circle to Bin"
  }

  var body: some View {
    VStack {
      Button {
        if feedbackMessage == "Reset" {
          resetGame()
        }
      } label: {
        Text(feedbackMessage)
      }
      .buttonStyle(.borderedProminent)
      .frame(maxWidth: .infinity, alignment: .center)

      ZStack {
        HStack(spacing: 20) {
          ForEach(bins, id: \.self) { color in
            DropBin(color: color, circles: $circles, feedbackMessage: $feedbackMessage, shake: $shake, resetGame: resetGame)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

        ForEach(circles, id: \.id) { circle in
          Circle()
            .fill(circle.color)
            .contentShape(.dragPreview, Circle())
            .draggable(CircleData(id: circle.id)) {
              Circle()
                .fill(circle.color)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
            .frame(width: 50, height: 50)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .offset(x: (shake ? -5 : 0) + circle.position.x)

        }
      }
      .animation(.spring(), value: shake)
    }
  }
}

struct DropBin: View {
  let color: Color
  @Binding var circles: [(id: UUID, color: Color, position: CGPoint)]
  @Binding var feedbackMessage: String
  @Binding var shake: Bool
  let resetGame: () -> Void

  var body: some View {
    RoundedRectangle(cornerRadius: 10)
      .fill(color.opacity(0.3))
      .frame(width: 80, height: 80)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(color, lineWidth: 2)
      )
      .dropDestination(for: CircleData.self) { items, _ in
        guard let item = items.first else { return false }
        if let index = circles.firstIndex(where: { $0.id == item.id }) {
          if circles[index].color == color {
            withAnimation(.easeInOut) {
              circles.remove(at: index)
              feedbackMessage = circles.isEmpty ? "Reset" : "Correct!"
              if !circles.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  feedbackMessage = "Long Press to Drag&Drop Circle to Bin"
                }
              }
            }
            return true
          } else {
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3)) {
              shake.toggle()
            }
            feedbackMessage = "Wrong bin!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              feedbackMessage = "Long Press to Drag&Drop Circle to Bin"
            }
            return false
          }
        }
        return false
      }
  }
}

#Preview {
  ColorSortingDragDrop()
}
