//
/*

  Filename: FlappyBirdView+Extensions.swift
 Project: Flappy Builder


  Created by John Durcan on 08/10/2025.

  Copyright © 2025 Itch Studio Ltd.. All rights reserved.

  Company No. 14729010. Registered Address: 128, City Road, London, EC1V 2NX 

All rights reserved. This software and associated documentation files (the "Software") are proprietary and confidential to Itch Studio Ltd. No part of the Software may be reproduced, distributed, modified, or used in any manner without prior written permission from Itch Studio Ltd., except as permitted by applicable law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL ITCH STUDIO LTD. BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  File Description:
  
*/
import SwiftUI

extension FlappyBirdView {
  // MARK: ViewBuilders

  // Score display
  var scoreOverlay: some View {
    VStack {
      Text("Score: \(score)")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
        .padding(.top, 20)
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }


  func mainContent(geometry: GeometryProxy) -> some View {
    ZStack {
      LinearGradient(
        gradient: config.skyGradient,
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()

      hillsLayer(geometry: geometry)
      backgroundLayer(geometry: geometry)
      pipesLayer(geometry: geometry)
      bird(geometry: geometry)
    }
    .ignoresSafeArea()
    .frame(width: geometry.size.width, height: geometry.size.height)
  }

  // Bird
  func bird(geometry: GeometryProxy) -> some View {
    Image(systemName: "bird.fill")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 50, height: 50)
      .offset(y: birdOffsetY)
      .foregroundColor(.blue)

  }

  func hillsLayer(geometry: GeometryProxy) -> some View {
    HStack(spacing: 0) {
      ForEach(0..<hillSegmentConfigs.count, id: \.self) { i in
        hillContent(segment: hillSegmentConfigs[i], width: geometry.size.width * config.segmentWidthMultiplier, height: geometry.size.height)
      }
    }
    .offset(x: hillOffset)
    .onReceive(timer) { _ in
      if !isGameOver, let width = screenSize?.width {
        hillOffset -= config.hillSpeed
        // Seamless looping with recycling
        let segmentWidth = width * config.segmentWidthMultiplier
        if hillOffset <= -segmentWidth {
          hillOffset += segmentWidth
          if let height = screenSize?.height {
            hillSegmentConfigs.removeFirst()
            hillSegmentConfigs.append(builder.generateNewHillSegment(width: segmentWidth, height: height))
          }
        }
      }
    }
  }

  func pipesLayer(geometry: GeometryProxy) -> some View {
    HStack(spacing: 0) {
      ForEach(0..<pipeSegmentConfigs.count, id: \.self) { i in
        pipeContent(segment: pipeSegmentConfigs[i], width: geometry.size.width * config.segmentWidthMultiplier, height: geometry.size.height)
      }
    }
    .offset(x: pipeOffset)
    .onReceive(timer) { _ in
      if !isGameOver, let width = screenSize?.width {
        pipeOffset -= config.pipeSpeed
        // Seamless looping with recycling
        let segmentWidth = width * config.segmentWidthMultiplier
        if pipeOffset <= -segmentWidth {
          pipeOffset += segmentWidth
          if let height = screenSize?.height {
            pipeSegmentConfigs.removeFirst()
            pipeSegmentConfigs.append(builder.generateNewPipeSegment(width: segmentWidth, height: height, score: score))
          }
        }
      }
    }
  }

  func backgroundLayer(geometry: GeometryProxy) -> some View {
    HStack(spacing: 0) {
      ForEach(0..<segmentConfigs.count, id: \.self) { i in
        backgroundContent(segment: segmentConfigs[i], width: geometry.size.width * config.segmentWidthMultiplier, height: geometry.size.height)
      }
    }
    .offset(x: backgroundOffset)
    .onReceive(timer) { _ in
      if !isGameOver, let width = screenSize?.width {
        backgroundOffset -= config.backgroundSpeed
        // Seamless looping with recycling
        let segmentWidth = width * config.segmentWidthMultiplier
        if backgroundOffset <= -segmentWidth {
          backgroundOffset += segmentWidth
          if let height = screenSize?.height {
            segmentConfigs.removeFirst()
            segmentConfigs.append(builder.generateNewSegment(width: segmentWidth, height: height))
          }
        }
      }
    }
  }

  @ViewBuilder
  func backgroundContent(segment: SegmentConfig, width: CGFloat, height: CGFloat) -> some View {
    ZStack {
      // Buildings
      ForEach(0..<segment.buildings.count, id: \.self) { j in
        let config = segment.buildings[j]
        Image(systemName: config.symbol)
          .resizable()
          .scaledToFit()
          .frame(width: config.width, height: config.height)
          .foregroundColor(self.config.buildingColor.opacity(config.opacity))
          .offset(x: config.x, y: config.y)
      }

      // Sun
      if let sun = segment.sun {
        Image(systemName: "sun.max.fill")
          .resizable()
          .scaledToFit()
          .frame(width: self.config.sunSize, height: self.config.sunSize)
          .foregroundColor(self.config.sunColor.opacity(0.8))
          .offset(x: sun.x, y: sun.y)
      }

      // Clouds
      ForEach(0..<segment.clouds.count, id: \.self) { j in
        let config = segment.clouds[j]
        Image(systemName: "cloud.fill")
          .resizable()
          .scaledToFit()
          .frame(width: config.size, height: config.size * 0.6)
          .foregroundColor(self.config.cloudColor.opacity(config.opacity))
          .offset(x: config.x, y: config.y)
      }
    }
    .frame(width: width, height: height)
  }

  @ViewBuilder
  func pipeContent(segment: PipeSegmentConfig, width: CGFloat, height: CGFloat) -> some View {
    ZStack {
      ForEach(0..<segment.pipes.count, id: \.self) { j in
        let pipe = segment.pipes[j]
        if let bh = pipe.bottomHeight {
          // Bottom pipe
          Rectangle()
            .fill(config.pipeColor)
            .frame(width: config.pipeWidth, height: bh)
            .offset(x: pipe.x, y: height / 2 - bh / 2)
          // Cap at top
          Rectangle()
            .fill(config.pipeColor)
            .frame(width: config.pipeCapWidth, height: config.pipeCapHeight)
            .offset(x: pipe.x, y: height / 2 - bh - config.pipeCapHeight / 2)
        }
        if let th = pipe.topHeight {
          // Top pipe
          Rectangle()
            .fill(config.pipeColor)
            .frame(width: config.pipeWidth, height: th)
            .offset(x: pipe.x, y: -height / 2 + th / 2)
          // Cap at bottom
          Rectangle()
            .fill(config.pipeColor)
            .frame(width: config.pipeCapWidth, height: config.pipeCapHeight)
            .offset(x: pipe.x, y: -height / 2 + th + config.pipeCapHeight / 2)
        }
      }
    }
    .frame(width: width, height: height)
  }

  @ViewBuilder
  func hillContent(segment: HillSegmentConfig, width: CGFloat, height: CGFloat) -> some View {
    ZStack {
      ForEach(0..<segment.hills.count, id: \.self) { j in
        let hill = segment.hills[j]
        Ellipse()
          .fill(config.hillColor.opacity(hill.opacity))
          .frame(width: hill.width, height: hill.height)
          .offset(x: hill.x, y: hill.y)
      }
    }
    .frame(width: width, height: height)
  }
}
