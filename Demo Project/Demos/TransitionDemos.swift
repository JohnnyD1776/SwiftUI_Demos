//
//  TransitionDemos.swift
//
//  Created by John Durcan on 02/09/2025.
//
import SwiftUI

struct TransitionGallery: View {
  @State private var show = false
  @State private var selectedTransition = 0
  @State private var selectedAnimation = 0

  let transitions: [(String, AnyTransition)] = [
    ("Identity", .identity),
    ("Opacity", .opacity),
    ("Scale", .scale),
    ("Slide", .slide),
    ("Move (Leading)", .move(edge: .leading)),
    ("Move (Trailing)", .move(edge: .trailing)),
    ("Move (Top)", .move(edge: .top)),
    ("Move (Bottom)", .move(edge: .bottom)),
    ("Push (Leading)", .push(from: .leading)),
    ("Push (Trailing)", .push(from: .trailing)),
    ("Push (Top)", .push(from: .top)),
    ("Push (Bottom)", .push(from: .bottom)),
    ("Opacity + Scale", .opacity.combined(with: .scale)),
    ("Move + Opacity", .move(edge: .leading).combined(with: .opacity)),
    ("Rotate + Fade", .rotateAndFade),
    ("Blur + Scale", .blurAndScale)
  ]

  let animations: [(String, Animation)] = [
    ("EaseInOut", .easeInOut(duration: 0.6)),
    ("EaseIn", .easeIn(duration: 0.6)),
    ("EaseOut", .easeOut(duration: 0.6)),
    ("Linear", .linear(duration: 0.6)),
    ("Spring", .spring(response: 0.6, dampingFraction: 0.7)),
    ("Bouncy Curve", .timingCurve(0.68, -0.55, 0.27, 1.55, duration: 1.0))
  ]

  var body: some View {
    VStack(spacing: 20) {
      VStack {
        ZStack {
          if show {
            RoundedRectangle(cornerRadius: 16)
              .fill(Color.blue.gradient)
              .frame(width: 200, height: 120)
              .transition(transitions[selectedTransition].1)
          }
        }
        .animation(animations[selectedAnimation].1, value: show)
      }
      .frame(height: 220)
      VStack {
        Text("\(transitions[selectedTransition].0) + \(animations[selectedAnimation].0)")
          .font(.headline)

        Button(show ? "Hide" : "Show") {
          show.toggle()
        }
        .buttonStyle(.borderedProminent)
        // 🔹 Scrollable Grids
        ScrollView {
          Text("Transitions")
            .font(.title3).bold()
            .frame(maxWidth: .infinity, alignment: .leading)

          LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            ForEach(0..<transitions.count, id: \.self) { i in
              Text(transitions[i].0)
                .font(.caption)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(selectedTransition == i ? Color.blue.opacity(0.3) : Color.gray.opacity(0.15))
                .cornerRadius(8)
                .onTapGesture { selectedTransition = i }
            }
          }
          .padding(.bottom, 16)

          Text("Animations")
            .font(.title3).bold()
            .frame(maxWidth: .infinity, alignment: .leading)

          LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            ForEach(0..<animations.count, id: \.self) { i in
              Text(animations[i].0)
                .font(.caption)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(selectedAnimation == i ? Color.green.opacity(0.3) : Color.gray.opacity(0.15))
                .cornerRadius(8)
                .onTapGesture { selectedAnimation = i }
            }
          }
        }
        .padding(.horizontal)
      }
    }
    .padding()
  }
}

extension AnyTransition {
  static var rotateAndFade: AnyTransition {
    .modifier(
      active: RotateAndFadeModifier(angle: 90, opacity: 0),
      identity: RotateAndFadeModifier(angle: 0, opacity: 1)
    )
  }

  static var blurAndScale: AnyTransition {
    .modifier(
      active: BlurAndScaleModifier(blur: 10, scale: 0.3),
      identity: BlurAndScaleModifier(blur: 0, scale: 1)
    )
  }
}

// MARK: - Custom Modifiers
struct RotateAndFadeModifier: ViewModifier {
  var angle: Double
  var opacity: Double

  func body(content: Content) -> some View {
    content
      .rotationEffect(.degrees(angle))
      .opacity(opacity)
  }
}

struct BlurAndScaleModifier: ViewModifier {
  var blur: CGFloat
  var scale: CGFloat

  func body(content: Content) -> some View {
    content
      .blur(radius: blur)
      .scaleEffect(scale)
  }
}


#Preview {
  TransitionGallery()
}
