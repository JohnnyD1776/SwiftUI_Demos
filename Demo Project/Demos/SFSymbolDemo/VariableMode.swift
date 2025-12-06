//
/*

  Filename: VariableMode.swift
 Project: Demo Project


  Created by John Durcan on 06/12/2025.

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

enum VariableMode: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case none
    case color
    case draw
    
    var title: String {
        switch self {
        case .none: return "None"
        case .color: return "Color"
        case .draw: return "Draw (iOS 18+)"
        }
    }
    
    var isIOS18: Bool {
        switch self {
        case .draw: return true
        default: return false
        }
    }
    
    @ViewBuilder
    func applyMode<T: View>(to content: T, value: Double) -> some View {
        switch self {
        case .none:
            content
        case .color:
            if #available(iOS 26.0, *) {
                content.symbolVariableValueMode(.color)
            } else {
                content
            }
        case .draw:
            if #available(iOS 26.0, *) {
                content.symbolVariableValueMode(.draw)
            } else {
                content
            }
        }
    }
    
    var code: String {
        switch self {
        case .none: return ""
        case .color: return ".symbolEffect(.variableColor, value: progress) // progress ranges from 0...1"
        case .draw: return ".variableValue(progress).symbolVariableValueMode(.draw) // progress ranges from 0...1"
        }
    }
}

