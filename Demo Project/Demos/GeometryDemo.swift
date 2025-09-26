//
//  GeometryDemo.swift
//  A Better Habit Tracker
//
//  Created by John Durcan on 25/09/2025.
//

import SwiftUI

struct Card: Identifiable {
  let id = UUID()
  let title: String
  let color: Color
  let detailText: String
}

struct GeometryDemoView: View {
  @Namespace private var animationNamespace
  @State private var selectedCard: Card?

  private let columns = [GridItem(.flexible()), GridItem(.flexible())]

  private let cardSpring = Animation.spring(response: 0.9, dampingFraction: 0.7)

  let cards = [
    Card(title: "Sunset", color: .orange, detailText: "A warm sunset glow"),
    Card(title: "Ocean", color: .blue, detailText: "Deep ocean vibes"),
    Card(title: "Forest", color: .green, detailText: "Lush forest greenery"),
    Card(title: "Night", color: .purple, detailText: "Mystical night sky")
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
          Image(systemName: "star.fill")
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
