//
/*

  Filename: to.swift
 Project: Flappy Builder


  Created by John Durcan on 08/10/2025.

  Copyright © 2025 Itch Studio Ltd.. All rights reserved.

  Company No. 14729010. Registered Address: 128, City Road, London, EC1V 2NX 

All rights reserved. This software and associated documentation files (the "Software") are proprietary and confidential to Itch Studio Ltd. No part of the Software may be reproduced, distributed, modified, or used in any manner without prior written permission from Itch Studio Ltd., except as permitted by applicable law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL ITCH STUDIO LTD. BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  File Description:
  
*/
import SwiftUI

// Builder class to handle segment generation
struct GameSegmentBuilder {
  let config: BackgroundConfig

  func generateNewSegment(width: CGFloat, height: CGFloat) -> SegmentConfig {
    // Buildings: Distribute across zones with randomness
    var buildings: [BuildingConfig] = []
    let buildingZoneWidth = width / CGFloat(config.buildingsPerSegment)
    for i in 0..<config.buildingsPerSegment {
      let symbol = config.buildingSymbols.randomElement() ?? config.buildingSymbols[0]
      let bWidth = CGFloat.random(in: config.buildingWidthRange)
      let bHeight = CGFloat.random(in: config.buildingHeightRange)
      // Center of the i-th zone, with random offset within fraction of the zone width
      let zoneCenter = -width / 2 + buildingZoneWidth * (CGFloat(i) + 0.5)
      let x = zoneCenter + CGFloat.random(in: -buildingZoneWidth * config.buildingZoneOffsetFraction ... buildingZoneWidth * config.buildingZoneOffsetFraction)
      let y = height / 2 - bHeight / 2 + CGFloat.random(in: config.buildingYOffsetVariation) // Slight variation for skyline
      let opacity = Double.random(in: config.buildingOpacityRange)
      buildings.append(BuildingConfig(symbol: symbol, width: bWidth, height: bHeight, x: x, y: y, opacity: opacity))
    }

    // Clouds: Distribute across zones with minimum spacing and randomness
    var clouds: [CloudConfig] = []
    let cloudZoneWidth = width / CGFloat(config.cloudsPerSegment)
    var usedXPositions: [CGFloat] = []
    for i in 0..<config.cloudsPerSegment {
      let size = CGFloat.random(in: config.cloudSizeRange)
      let zoneCenter = -width / 2 + cloudZoneWidth * (CGFloat(i) + 0.5)
      var x = zoneCenter + CGFloat.random(in: -cloudZoneWidth * config.cloudZoneOffsetFraction ... cloudZoneWidth * config.cloudZoneOffsetFraction)
      // Ensure minimum spacing
      while usedXPositions.contains(where: { abs($0 - x) < config.cloudMinSpacing }) {
        x = zoneCenter + CGFloat.random(in: -cloudZoneWidth * config.cloudZoneOffsetFraction ... cloudZoneWidth * config.cloudZoneOffsetFraction)
      }
      usedXPositions.append(x)
      let y = CGFloat.random(in: -height * config.cloudYRangeFraction.max ... -height * config.cloudYRangeFraction.min)
      let opacity = Double.random(in: config.cloudOpacityRange)
      clouds.append(CloudConfig(size: size, x: x, y: y, opacity: opacity))
    }

    // Sun: Random but avoid cloud-heavy zones
    let sun: SunConfig? = Double.random(in: 0...1) < config.sunProbability ? {
      let sunX = CGFloat.random(in: -width * config.sunXRangeFraction ... width * config.sunXRangeFraction)
      return SunConfig(x: sunX, y: -height * config.sunYFraction)
    }() : nil

    return SegmentConfig(buildings: buildings, clouds: clouds, sun: sun)
  }

  func generateNewPipeSegment(width: CGFloat, height: CGFloat, score: Int) -> PipeSegmentConfig {
    let maxHeight = height * config.pipeHeightMaxFraction
    let pipeHeightRange: ClosedRange<CGFloat> = config.pipeHeightMin...maxHeight

    // Increasing difficulty: Reduce gap as score increases
    let difficultyFactor = min(1.0, CGFloat(score) / 3.0) // Ramp up over 50 points
    let minGap = config.pipeGapRange.lowerBound * (1 - 0.5 * difficultyFactor) // Reduce by up to 50%
    let maxGap = config.pipeGapRange.upperBound * (1 - 0.5 * difficultyFactor)
    let pipeGapRangeAdjusted = minGap...maxGap

    // Pipes: Distribute across zones with minimum spacing
    var pipes: [PipeConfig] = []
    let pipeZoneWidth = width / CGFloat(config.pipesPerSegment)
    var usedXPositions: [CGFloat] = []
    for i in 0..<config.pipesPerSegment {
      let zoneCenter = -width / 2 + pipeZoneWidth * (CGFloat(i) + 0.5)
      var x = zoneCenter + CGFloat.random(in: -pipeZoneWidth * config.pipeZoneOffsetFraction ... pipeZoneWidth * config.pipeZoneOffsetFraction)
      // Ensure minimum spacing
      while usedXPositions.contains(where: { abs($0 - x) < config.pipeMinSpacing }) {
        x = zoneCenter + CGFloat.random(in: -pipeZoneWidth * config.pipeZoneOffsetFraction ... pipeZoneWidth * config.pipeZoneOffsetFraction)
      }
      usedXPositions.append(x)

      let style = Int.random(in: 0...2)
      switch style {
      case 0: // Single from ground
        let bottomHeight = CGFloat.random(in: pipeHeightRange)
        pipes.append(PipeConfig(x: x, bottomHeight: bottomHeight, topHeight: nil))
      case 1: // Single from top
        let topHeight = CGFloat.random(in: pipeHeightRange)
        pipes.append(PipeConfig(x: x, bottomHeight: nil, topHeight: topHeight))
      default: // Double
        let pipeGap = CGFloat.random(in: pipeGapRangeAdjusted)
        let minH = config.pipeHeightMin
        let maxH = maxHeight
        let lowerBound = max(minH, height - pipeGap - maxH)
        let upperBound = min(maxH, height - pipeGap - minH)
        let bottomHeight = CGFloat.random(in: lowerBound ... upperBound)
        let topHeight = height - pipeGap - bottomHeight
        pipes.append(PipeConfig(x: x, bottomHeight: bottomHeight, topHeight: topHeight))
      }
    }

    return PipeSegmentConfig(pipes: pipes)
  }

  func generateEmptyPipeSegment() -> PipeSegmentConfig {
    return PipeSegmentConfig(pipes: []) // Empty segment with no pipes
  }

  func generateNewHillSegment(width: CGFloat, height: CGFloat) -> HillSegmentConfig {
    var hillPositions: [CGFloat] = []
    var currentX = -width / 2 + CGFloat.random(in: 0 ... config.hillSpacingRange.lowerBound / 4)
    for _ in 0..<config.hillsPerSegment {
      hillPositions.append(currentX)
      let spacing = CGFloat.random(in: config.hillSpacingRange)
      currentX += spacing
    }

    var hills: [HillConfig] = []
    for pos in hillPositions {
      let hWidth = CGFloat.random(in: config.hillWidthRange)
      let hHeight = CGFloat.random(in: config.hillHeightRange)
      let x = pos
      let y = height / 2 - hHeight / 2 - height * config.hillYFraction // Position near bottom
      let opacity = Double.random(in: config.hillOpacityRange)
      hills.append(HillConfig(width: hWidth, height: hHeight, x: x, y: y, opacity: opacity))
    }

    return HillSegmentConfig(hills: hills)
  }
}
