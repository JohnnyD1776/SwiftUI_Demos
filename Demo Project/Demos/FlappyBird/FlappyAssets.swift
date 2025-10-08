/*

 Filename: FlappyBirdDemo.swift
 Project: Demo Project


 Created by John Durcan on 06/10/2025.

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
import Combine
import SwiftUI

// <-- File: AssetsConfigs.swift

struct BuildingConfig {
  let symbol: String
  let width: CGFloat
  let height: CGFloat
  let x: CGFloat
  let y: CGFloat
  let opacity: Double
}

struct CloudConfig {
  let size: CGFloat
  let x: CGFloat
  let y: CGFloat
  let opacity: Double
}

struct SunConfig {
  let x: CGFloat
  let y: CGFloat
}

struct HillConfig {
  let width: CGFloat
  let height: CGFloat
  let x: CGFloat
  let y: CGFloat
  let opacity: Double
}

struct SegmentConfig {
  let buildings: [BuildingConfig]
  let clouds: [CloudConfig]
  let sun: SunConfig?
}

struct PipeConfig {
  let id: UUID = UUID() // Unique ID for tracking passed pipes
  let x: CGFloat
  let bottomHeight: CGFloat?
  let topHeight: CGFloat?
}

struct PipeSegmentConfig {
  let pipes: [PipeConfig]
}

struct HillSegmentConfig {
  let hills: [HillConfig]
}
