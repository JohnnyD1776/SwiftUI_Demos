//
/*

  Filename: PaddingAroundSensorIsland.swift
 Project: Demo Project


  Created by John Durcan on 13/10/2025.

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

import SwiftUI

// MARK: - Your Original Modifier (unchanged)
struct IgnoreSafeAreaRespectSensorIsland: ViewModifier {
  func body(content: Content) -> some View {
    GeometryReader { geometry in
      let insets = geometry.safeAreaInsets
      let edgesToIgnore = computeEdgesToIgnore(for: insets)

      content
        .ignoresSafeArea(edges: edgesToIgnore)
    }
  }

  private func computeEdgesToIgnore(for insets: EdgeInsets) -> Edge.Set {
#if os(iOS)
    if UIDevice.current.userInterfaceIdiom == .phone {
      let threshold: CGFloat = 44
      let hasLeadingSensor = insets.leading > threshold
      let hasTrailingSensor = insets.trailing > threshold
      let hasTopSensor = insets.top > threshold
      let hasBottomSensor = insets.bottom > threshold

      guard hasLeadingSensor || hasTrailingSensor || hasTopSensor || hasBottomSensor else {
        return .all
      }

      var edges: Edge.Set = .all
      if hasLeadingSensor && hasTrailingSensor {
        edges.remove(UIDevice.current.orientation == .landscapeRight ? .trailing : .leading)
      } else {
        if hasLeadingSensor {
          edges.remove(.leading)
        }
        if hasTrailingSensor {
          edges.remove(.trailing)
        }
        if hasTopSensor {
          edges.remove(.top)
        }
        if hasBottomSensor {
          edges.remove(.bottom)
        }
      }
      return edges
    } else {
      return .all
    }
#else
    return .all
#endif
  }
}

extension View {
  func ignoreSafeAreaRespectSensorIsland() -> some View {
    modifier(IgnoreSafeAreaRespectSensorIsland())
  }
}

// MARK: - Demo Content View
struct SensorIslandDemoView: View {
  @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation

  var body: some View {
    VStack {
      Text("Orientation: \(orientation.isLandscape ? "Landscape" : "Portrait")")
        .font(.title)
        .textCase(.uppercase)
        .padding(22)
      Text("Demonstrates Padding to the Sensor Housing Only.\n\nNote, Preview does not update Orientation consistently. Test on Simulator/Device.")
        .padding(22)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 44)
        .font(.title3)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.green)
    .overlay {
      overlayContent
        .ignoreSafeAreaRespectSensorIsland()
    }
  }

  private var overlayContent:some View {
    GeometryReader { proxy in
      ZStack {
        HStack {
          Text(".leading = \(Int(proxy.safeAreaInsets.leading))")
            .background(content: {
              RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.yellow)
                .frame(width: 130,height: 33)
            })
            .frame(maxHeight: .infinity, alignment: .center)
            .rotationEffect(Angle(degrees: 270))
            .padding(0)
          Spacer()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        HStack {
          Spacer()
          Text(".trailing = \(Int(proxy.safeAreaInsets.trailing))")
            .background(content: {
              RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.yellow)
                .frame(width: 130,height: 33)
            })
            .frame(maxHeight: .infinity, alignment: .center)
            .rotationEffect(Angle(degrees: 90))
            .padding(0)
        }

        VStack {
          Text(".top = \(Int(proxy.safeAreaInsets.top))")
            .background(content: {
              RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.yellow)
                .frame(width: 130,height: 33)
            })
            .padding(22)
          Spacer()
            .frame(maxHeight: .infinity, alignment: .center)
        }
        VStack {
          Spacer()
            .frame(maxHeight: .infinity, alignment: .center)
          Text(".bottom = \(Int(proxy.safeAreaInsets.bottom))")
            .background(content: {
              RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.yellow)
                .frame(width: 130,height: 33)
            })
            .padding(22)
        }
      }
    }
  }

  // MARK: - Helper: Detect Sensor Edge (now supports top/bottom)
  private func detectSensorEdge(insets: EdgeInsets, orientation: UIDeviceOrientation, threshold: CGFloat = 44) -> Edge? {
    let isLandscape = orientation == .landscapeLeft || orientation == .landscapeRight
    let isPortrait = orientation == .portrait || orientation == .portraitUpsideDown

    let hasTop = insets.top > threshold
    let hasBottom = insets.bottom > threshold
    let hasLeading = insets.leading > threshold
    let hasTrailing = insets.trailing > threshold

    if isLandscape {
      // Landscape: Prefer sides
      if hasLeading && hasTrailing {
        return orientation == .landscapeRight ? .trailing : .leading
      } else if hasLeading {
        return .leading
      } else if hasTrailing {
        return .trailing
      }
    } else if isPortrait {
      // Portrait: Prefer top/bottom
      if orientation == .portrait && hasTop {
        return .top
      } else if orientation == .portraitUpsideDown && hasBottom {
        return .bottom
      }
    }

    // Fallback: Any large edge
    if hasTop { return .top }
    if hasBottom { return .bottom }
    if hasLeading { return .leading }
    if hasTrailing { return .trailing }
    return nil
  }

}


// MARK: - Main View
struct SensorIslandView: View {
  var body: some View {
    SensorIslandDemoView()
  }
}

// MARK: - Previews
#Preview {
  SensorIslandView()
}
