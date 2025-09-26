/*

 Filename: GeometryDemo.swift
 Project: Demo Project


 Created by John Durcan on 25/09/2025.

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
Presents Matched Geometry effects
 */

import SwiftUI

struct Card: Identifiable {
  let id = UUID()
  let title: String
  let color: Color
  let detailText: String
  let systemImageName: String
}

struct GeometryDemoView: View {
  @Namespace private var animationNamespace
  @State private var selectedCard: Card?

  private let columns = [GridItem(.flexible()), GridItem(.flexible())]

  private let cardSpring = Animation.spring(response: 0.3, dampingFraction: 0.7)

  let cards = [
    Card(title: "Sunset", color: .orange, detailText: "A warm sunset glow", systemImageName: "sun.max.fill"),
    Card(title: "Ocean", color: .blue, detailText: "Deep ocean vibes", systemImageName: "drop.fill"),
    Card(title: "Forest", color: .green, detailText: "Lush forest greenery", systemImageName: "leaf.fill"),
    Card(title: "Night", color: .purple, detailText: "Mystical night sky", systemImageName: "moon.stars.fill")
  ]

  var body: some View {
    ZStack {
      Color(.systemBackground)
        .ignoresSafeArea()

      if selectedCard == nil {
        ScrollView {
          LazyVGrid(columns: columns, spacing: 20) {
            ForEach(cards) { card in
              CardView(card: card, namespace: animationNamespace)
                .onTapGesture {
                  withAnimation(cardSpring) {
                    selectedCard = card
                  }
                }
            }
          }
          .padding()
        }
      }

      if let selectedCard = selectedCard {
        DetailView(
          card: selectedCard,
          namespace: animationNamespace,
          onDismiss: {
            withAnimation(cardSpring) {
              self.selectedCard = nil
            }
          }
        )
        .zIndex(1)
      }
    }
  }
}

struct CardView: View {
  let card: Card
  let namespace: Namespace.ID

  var body: some View {
    CardFace(
      card: card,
      namespace: namespace,
      iconSize: 50,
      iconImageFont: nil,
      titleFont: .headline,
      isTitleBold: false
    )
    .padding()
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 15)
        .fill(card.color.opacity(0.1))
        .shadow(radius: 5)
        .matchedGeometryEffect(id: "background_\(card.id)", in: namespace)
    )
  }
}

struct DetailView: View {
  let card: Card
  let namespace: Namespace.ID
  let onDismiss: () -> Void

  var body: some View {
    VStack(spacing: 20) {
      // Close button
      HStack {
        Spacer()
        Button(action: onDismiss) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
            .font(.title2)
        }
        .padding(.trailing)
      }

      CardFace(
        card: card,
        namespace: namespace,
        iconSize: 100,
        iconImageFont: .largeTitle,
        titleFont: .largeTitle,
        isTitleBold: true
      )

      Text(card.detailText)
        .font(.body)
        .foregroundColor(.secondary)
        .padding()

      Spacer()
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 25)
        .fill(card.color.opacity(0.1))
        .shadow(radius: 10)
        .matchedGeometryEffect(id: "background_\(card.id)", in: namespace)
        .ignoresSafeArea()
    )
  }
}

private struct CardFace: View {
  let card: Card
  let namespace: Namespace.ID
  let iconSize: CGFloat
  let iconImageFont: Font?
  let titleFont: Font
  let isTitleBold: Bool

  var body: some View {
    VStack {
      RoundedRectangle(cornerRadius: iconSize / 5)
        .fill(card.color.opacity(0.3))
        .frame(width: iconSize, height: iconSize)
        .matchedGeometryEffect(id: "icon_\(card.id)", in: namespace)
        .overlay(
          Image(systemName: card.systemImageName)
            .foregroundColor(card.color)
            .modifier(IconFont(font: iconImageFont))
            .matchedGeometryEffect(id: "iconImage_\(card.id)", in: namespace)
        )

      Text(card.title)
        .font(titleFont)
        .bold()
        .frame(maxWidth: .infinity)
        .foregroundColor(.primary)
        .matchedGeometryEffect(id: "title_\(card.id)", in: namespace)
    }
  }

  private struct IconFont: ViewModifier {
    let font: Font?
    func body(content: Content) -> some View {
      if let font { content.font(font) } else { content }
    }
  }
}

struct GeometryDemoView_Previews: PreviewProvider {
  static var previews: some View {
    GeometryDemoView()
  }
}
