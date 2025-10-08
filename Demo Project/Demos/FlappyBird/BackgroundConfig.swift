//
/*

  Filename: for.swift
 Project: Flappy Builder


  Created by John Durcan on 08/10/2025.

  Copyright © 2025 Itch Studio Ltd.. All rights reserved.

  Company No. 14729010. Registered Address: 128, City Road, London, EC1V 2NX 

All rights reserved. This software and associated documentation files (the "Software") are proprietary and confidential to Itch Studio Ltd. No part of the Software may be reproduced, distributed, modified, or used in any manner without prior written permission from Itch Studio Ltd., except as permitted by applicable law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL ITCH STUDIO LTD. BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  File Description:
  
*/
import SwiftUI





// Configuration struct for background customization
struct BackgroundConfig {
  // Building settings
  let buildingSymbols: [String] = ["building.fill", "building.2.fill", "house.fill"]
  let buildingsPerSegment: Int = 8
  let buildingWidthRange: ClosedRange<CGFloat> = 50...120
  let buildingHeightRange: ClosedRange<CGFloat> = 100...250
  let buildingYOffsetVariation: ClosedRange<CGFloat> = -30...30
  let buildingOpacityRange: ClosedRange<Double> = 0.4...0.7
  let buildingZoneOffsetFraction: CGFloat = 0.4 // Fraction of zone width for random offset (0.0 = no randomness, 0.5 = half zone)

  // Cloud settings
  let cloudsPerSegment: Int = 5
  let cloudSizeRange: ClosedRange<CGFloat> = 80...150
  let cloudYRangeFraction: (min: CGFloat, max: CGFloat) = (min: 0.25, max: 0.5) // Fractions of height for y-range (higher values = lower in sky)
  let cloudOpacityRange: ClosedRange<Double> = 0.5...0.8
  let cloudZoneOffsetFraction: CGFloat = 0.3 // Fraction of zone width for random offset
  let cloudMinSpacing: CGFloat = 50 // Minimum horizontal spacing between clouds

  // Sun settings
  let sunProbability: Double = 0.5 // Chance of sun appearing in a segment (0.0 to 1.0)
  let sunSize: CGFloat = 60
  let sunXRangeFraction: CGFloat = 0.3 // Fraction of width for x-range (± width * fraction)
  let sunYFraction: CGFloat = 0.3 // Fraction of height for y-position (from top)

  // Pipe settings
  let pipeSpeed: CGFloat = 2.0
  let pipesPerSegment: Int = 9 // Increased for more pipes per segment
  let pipeZoneOffsetFraction: CGFloat = 0.4 // Fraction of zone width for random offset
  let pipeMinSpacing: CGFloat = 80 // Minimum horizontal spacing between pipes
  let pipeHeightMin: CGFloat = 20
  let pipeHeightMaxFraction: CGFloat = 2/3
  let pipeWidth: CGFloat = 20
  let pipeCapWidth: CGFloat = 30
  let pipeCapHeight: CGFloat = 30
  let pipeGapRange: ClosedRange<CGFloat> = 220...320 // Range for randomization per pipe
  let pipeColor: Color = .orange

  // Hill settings
  let hillSpeed: CGFloat = 1.5 // Speed for hills layer (between background and pipes)
  let hillsPerSegment: Int = 26 // Number of hills per segment
  let hillWidthRange: ClosedRange<CGFloat> = 150...300 // Width for oblong hills
  let hillHeightRange: ClosedRange<CGFloat> = 80...200 // Height for hills
  let hillSpacingRange: ClosedRange<CGFloat> = 20...150 // Spacing between hills
  let hillOpacityRange: ClosedRange<Double> = 0.7...0.9 // Opacity for hills
  let hillColor: Color = .green // Green color for hills
  let hillYFraction: CGFloat = -0.1 // Fraction of height from bottom for hill placement

  // General settings
  let backgroundSpeed: CGFloat = 1.0
  let segmentCount: Int = 4 // Number of segments for scrolling buffer
  let segmentWidthMultiplier: CGFloat = 2.0 // Segment width as multiple of screen width
  let buildingColor: Color = .gray
  let cloudColor: Color = .white
  let sunColor: Color = .yellow
  let skyGradient: Gradient = Gradient(colors: [.cyan.opacity(0.8), .blue.opacity(0.6)])
  let gravity: CGFloat = 0.2
  let jumpVelocity: CGFloat = -4.0
  let timerInterval: Double = 0.016 // ~60 FPS
}
// <- FILE: FlappyBirdDemo+ViewBuilders
