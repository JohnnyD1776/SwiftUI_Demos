//
/*

  Filename: FlappyBirdView.swift
 Project: Flappy Builder


  Created by John Durcan on 08/10/2025.

  Copyright © 2025 Itch Studio Ltd.. All rights reserved.

  Company No. 14729010. Registered Address: 128, City Road, London, EC1V 2NX 

All rights reserved. This software and associated documentation files (the "Software") are proprietary and confidential to Itch Studio Ltd. No part of the Software may be reproduced, distributed, modified, or used in any manner without prior written permission from Itch Studio Ltd., except as permitted by applicable law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL ITCH STUDIO LTD. BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  File Description:
  
*/
import SwiftUI
import Combine

struct FlappyBirdView: View {
  let config: BackgroundConfig // Configurable background settings
  let builder: GameSegmentBuilder // Builder for segment generation

  @State var birdOffsetY: CGFloat = 0
  @State var velocity: CGFloat = 0
  @State var backgroundOffset: CGFloat = 0
  @State var pipeOffset: CGFloat = 0
  @State var hillOffset: CGFloat = 0
  @State var isGameOver: Bool = false
  @State var segmentConfigs: [SegmentConfig] = []
  @State var pipeSegmentConfigs: [PipeSegmentConfig] = []
  @State var hillSegmentConfigs: [HillSegmentConfig] = []
  @State var screenSize: CGSize? = nil
  @State var timerPublisher = PassthroughSubject<Void, Never>()
  @State var score: Int = 0 // Score state
  @State var passedPipeIds: Set<UUID> = [] // Track passed pipes to increment score
  @State private var lastPipePositions: [UUID: CGFloat] = [:] // Track last x-position of pipes
  let timer: AnyPublisher<Void, Never>

  init(config: BackgroundConfig = BackgroundConfig()) {
    self.config = config
    self.builder = GameSegmentBuilder(config: config)
    self.timer = Timer
      .publish(every: config.timerInterval, on: .main, in: .common)
      .autoconnect()
      .map { _ in () }
      .eraseToAnyPublisher()
  }

  var body: some View {
    GeometryReader { geometry in
      let isLandscape = geometry.size.width > geometry.size.height

      ZStack {
        if isLandscape {
          mainContent(geometry: geometry)
            .contentShape(Rectangle()) // Makes entire view tappable
            .onTapGesture {
              if !isGameOver {
                velocity = config.jumpVelocity
              }
            }
            .transition(.opacity)
        } else {
          // Portrait overlay asking the user to rotate
          RotateDeviceOverlay()
            .transition(.opacity)
        }

        if isLandscape {
          scoreOverlay
        }

        if isLandscape, isGameOver {
          GameOverView(score: score, onReset: resetGame)
        }
      }
      .onAppear {
        // Initialize screenSize and segmentConfigs
        if screenSize == nil {
          screenSize = geometry.size
          setupAssets(geometry: geometry.size)
        }
      }
      .onChange(of: geometry.size) { _, newSize in
        // Update screenSize and regenerate segments on size change (e.g., rotation)
        let oldSize = screenSize
        screenSize = newSize

        // Only regenerate if the size has actually changed significantly
        if oldSize != newSize {
          setupAssets(geometry: newSize)
          // Reset game state if game over
          if isGameOver {
            resetGame()
          }
        }
      }
      .onReceive(timer) { _ in
        // Pause game updates while in portrait so the bird doesn’t fall, etc.
        if geometry.size.width > geometry.size.height {
          update(geometry: geometry)
        }
      }
    }
    .ignoresSafeArea()
  }

  // MARK: Game Logic Functions

  private func setupAssets(geometry newSize: CGSize) {
    let segmentWidth = newSize.width * config.segmentWidthMultiplier
    let totalWidth = CGFloat(config.segmentCount) * segmentWidth
    segmentConfigs = (0..<config.segmentCount).map { _ in
      builder.generateNewSegment(width: segmentWidth, height: newSize.height)
    }
    // First segment has no pipes
    pipeSegmentConfigs = [builder.generateEmptyPipeSegment()] + (0..<config.segmentCount-1).map { _ in
      builder.generateNewPipeSegment(width: segmentWidth, height: newSize.height, score: score)
    }
    hillSegmentConfigs = (0..<config.segmentCount).map { _ in
      builder.generateNewHillSegment(width: segmentWidth, height: newSize.height)
    }
    // Align left edge of first segment with screen's left edge, but shift to start midway into the empty segment
    let initialShift = newSize.width // Shift by 1 screen width into the empty segment
    backgroundOffset = totalWidth / 2 - newSize.width / 2 - initialShift
    pipeOffset = totalWidth / 2 - newSize.width / 2 - initialShift
    hillOffset = totalWidth / 2 - newSize.width / 2 - initialShift
  }

  private func update(geometry: GeometryProxy) {
    if !isGameOver {
      velocity += config.gravity
      birdOffsetY += velocity

      // Clamp to screen bounds and check ground collision
      let halfHeight = geometry.size.height / 2
      let birdHalfSize: CGFloat = 25 // Half of bird height/width
      let maxY = halfHeight - birdHalfSize

      // Ground collision (bottom of screen)
      if birdOffsetY > maxY {
        birdOffsetY = maxY
        velocity = 0
        isGameOver = true
        timerPublisher.send()
      }

      // Pipe collision and score update
      if let width = screenSize?.width, let height = screenSize?.height {
        let birdRect = CGRect(
          x: -15, // Center of bird (x=0), collision box 30x30
          y: birdOffsetY - 15,
          width: 30,
          height: 30
        )

        let segmentWidth = width * config.segmentWidthMultiplier
        let totalWidth = CGFloat(config.segmentCount) * segmentWidth

        for (index, segment) in pipeSegmentConfigs.enumerated() {
          let segmentOffset = CGFloat(index) * segmentWidth - totalWidth / 2 + 0.5 * segmentWidth
          for pipe in segment.pipes {
            let pipeX = pipe.x + pipeOffset + segmentOffset
            // Score: Increment only when pipe crosses from positive to non-positive x
            if let lastX = lastPipePositions[pipe.id] {
              if lastX > 0 && pipeX <= 0 && !passedPipeIds.contains(pipe.id) {
                score += 1
                passedPipeIds.insert(pipe.id)
              }
            }
            lastPipePositions[pipe.id] = pipeX // Update last known position

            // Only check pipes near the bird for collision
            if pipeX > -50 && pipeX < 50 {
              // Bottom pipe and cap
              if let bh = pipe.bottomHeight {
                let pipeRect = CGRect(
                  x: pipeX - config.pipeWidth / 2,
                  y: height / 2 - bh,
                  width: config.pipeWidth,
                  height: bh
                )
                let capRect = CGRect(
                  x: pipeX - config.pipeCapWidth / 2,
                  y: height / 2 - bh - config.pipeCapHeight,
                  width: config.pipeCapWidth,
                  height: config.pipeCapHeight
                )
                if birdRect.intersects(pipeRect) || birdRect.intersects(capRect) {
                  isGameOver = true
                  timerPublisher.send()
                  break
                }
              }
              // Top pipe and cap
              if let th = pipe.topHeight {
                let pipeRect = CGRect(
                  x: pipeX - config.pipeWidth / 2,
                  y: -height / 2,
                  width: config.pipeWidth,
                  height: th
                )
                let capRect = CGRect(
                  x: pipeX - config.pipeCapWidth / 2,
                  y: -height / 2 + th,
                  width: config.pipeCapWidth,
                  height: config.pipeCapHeight
                )
                if birdRect.intersects(pipeRect) || birdRect.intersects(capRect) {
                  isGameOver = true
                  timerPublisher.send()
                  break
                }
              }
            }
          }
          if isGameOver { break }
        }

        // Clean up lastPipePositions for pipes no longer in segments
        let currentPipeIds = pipeSegmentConfigs.flatMap { $0.pipes }.map { $0.id }
        lastPipePositions = lastPipePositions.filter { currentPipeIds.contains($0.key) }
      }
    }
  }

  private func resetGame() {
    birdOffsetY = 0
    velocity = 0
    backgroundOffset = 0
    pipeOffset = 0
    hillOffset = 0
    isGameOver = false
    score = 0 // Reset score
    passedPipeIds = [] // Reset passed pipes
    if let screenSize {
      setupAssets(geometry: screenSize)
    }
    timerPublisher = PassthroughSubject<Void, Never>()
  }
}

// MARK: - Rotate Overlay
private struct RotateDeviceOverlay: View {
  var body: some View {
    ZStack {
      LinearGradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.75)],
                     startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()

      VStack(spacing: 16) {
        Image(systemName: "iphone.landscape")
          .symbolRenderingMode(.hierarchical)
          .font(.system(size: 64, weight: .semibold))
          .foregroundStyle(.white)

        Text("Rotate to Landscape")
          .font(.title2).bold()
          .foregroundStyle(.white)

        Text("This game is best experienced in landscape.")
          .font(.subheadline)
          .foregroundStyle(.white.opacity(0.8))
      }
      .multilineTextAlignment(.center)
      .padding(24)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(Color.white.opacity(0.08))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .strokeBorder(Color.white.opacity(0.15))
      )
      .padding()
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel("Rotate to Landscape. This game is best experienced in landscape.")
  }
}

#Preview {
    FlappyBirdView()
}
