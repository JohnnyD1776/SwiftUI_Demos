//
/*
 
 Filename: StyledText.swift
 Project: Demo Project
 
 
 Created by John Durcan on 20/10/2025.
 
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
 
 File Description: Create styled Text
 
 */

import SwiftUI

/// A SwiftUI view that renders text with common BBCode tags, including newlines (\n) and [br].
/// Supported tags: [b], [i], [u], [s], [color=name|#hex], [url=link], [br].
struct StyledText: View {
  private let lines: [[TextSegment]]
  
  /// Initializes the view with a BBCode-marked-up string.
  init(_ markup: String) {
    self.lines = StyledText.parseMarkup(markup)
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      ForEach(lines.indices, id: \.self) { lineIndex in
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          ForEach(Array(lines[lineIndex].enumerated()), id: \.offset) { _, segment in
            if let urlString = segment.url, let url = URL(string: urlString) {
              Link(destination: url) {
                segment.text
                  .foregroundColor(.blue)
                  .underline()
              }
            } else {
              segment.text
            }
          }
        }
      }
    }
  }
  
  /// Represents a text segment with styling and optional URL.
  private struct TextSegment {
    let text: Text
    let url: String?
    
    init(content: String, isBold: Bool = false, isItalic: Bool = false, isUnderline: Bool = false, isStrikethrough: Bool = false, color: Color? = nil, url: String? = nil) {
      var text = Text(content)
      if isBold {
        text = text.bold()
      }
      if isItalic {
        text = text.italic()
      }
      if isUnderline {
        text = text.underline()
      }
      if isStrikethrough {
        text = text.strikethrough()
      }
      if let color = color {
        text = text.foregroundColor(color)
      }
      self.text = text
      self.url = url
    }
  }
  
  /// Parses the BBCode string into lines of styled text segments.
  private static func parseMarkup(_ markup: String) -> [[TextSegment]] {
    // Split input by newlines, preserving empty lines
    let lines = markup.components(separatedBy: .newlines)
    var result: [[TextSegment]] = []
    
    // Track styles across lines for consistency
    var isBold = false
    var isItalic = false
    var isUnderline = false
    var isStrikethrough = false
    var currentColor: Color?
    var currentURL: String?
    
    for line in lines {
      var segments: [TextSegment] = []
      var currentText = ""
      
      let scanner = Scanner(string: line)
      scanner.charactersToBeSkipped = nil
      
      while !scanner.isAtEnd {
        // Scan up to the next tag or end
        if let text = scanner.scanUpToString("["), !text.isEmpty {
          segments.append(TextSegment(
            content: text,
            isBold: isBold,
            isItalic: isItalic,
            isUnderline: isUnderline,
            isStrikethrough: isStrikethrough,
            color: currentColor,
            url: currentURL
          ))
          currentText = ""
        }
        
        // Check for a tag
        if scanner.scanString("[") != nil {
          if scanner.scanString("b]") != nil {
            isBold = true
          } else if scanner.scanString("/b]") != nil {
            isBold = false
          } else if scanner.scanString("i]") != nil {
            isItalic = true
          } else if scanner.scanString("/i]") != nil {
            isItalic = false
          } else if scanner.scanString("u]") != nil {
            isUnderline = true
          } else if scanner.scanString("/u]") != nil {
            isUnderline = false
          } else if scanner.scanString("s]") != nil {
            isStrikethrough = true
          } else if scanner.scanString("/s]") != nil {
            isStrikethrough = false
          } else if scanner.scanString("color=") != nil {
            if let colorName = scanner.scanUpToString("]"), scanner.scanString("]") != nil {
              currentColor = Color(fromString: colorName)
            }
          } else if scanner.scanString("/color]") != nil {
            currentColor = nil
          } else if scanner.scanString("url=") != nil {
            if let url = scanner.scanUpToString("]"), scanner.scanString("]") != nil {
              currentURL = url
            }
          } else if scanner.scanString("/url]") != nil {
            currentURL = nil
          } else if scanner.scanString("br]") != nil {
            // Add current segments as a line and start a new line
            if !segments.isEmpty || !currentText.isEmpty {
              if !currentText.isEmpty {
                segments.append(TextSegment(
                  content: currentText,
                  isBold: isBold,
                  isItalic: isItalic,
                  isUnderline: isUnderline,
                  isStrikethrough: isStrikethrough,
                  color: currentColor,
                  url: currentURL
                ))
              }
              result.append(segments)
              segments = []
              currentText = ""
            }
            continue
          } else {
            // Invalid tag, treat '[' as regular character
            currentText += "["
            continue
          }
        }
      }
      
      // Append any remaining text in the line
      if !currentText.isEmpty {
        segments.append(TextSegment(
          content: currentText,
          isBold: isBold,
          isItalic: isItalic,
          isUnderline: isUnderline,
          isStrikethrough: isStrikethrough,
          color: currentColor,
          url: currentURL
        ))
      }
      
      // Add the line to the result, even if empty
      result.append(segments)
    }
    
    return result
  }
}


extension Color {
  /// Creates a Color from a string (named color or hex).
  init?(fromString string: String) {
    let lower = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

    // Try hex in the form #RRGGBB
    if lower.hasPrefix("#"), lower.count == 7 {
      let hex = lower.dropFirst()
      if let value = UInt32(hex, radix: 16) {
        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0
        self = Color(red: red, green: green, blue: blue)
        return
      } else {
        return nil
      }
    }

    // Try named colors
    switch lower {
    case "red": self = .red; return
    case "blue": self = .blue; return
    case "green": self = .green; return
    case "black": self = .black; return
    case "white": self = .white; return
    default:
      return nil
    }
  }
}


// Preview provider for testing
struct StyledTextDemo: View {
  @State private var input: String = "Normal [b]Bold[/b] [i]Italic[/i] [u]Underline[/u] [s]Strikethrough[/s]\n[color=red]Red[/color] and [color=#0000FF]Blue[/color] text\n[url=https://example.com]Visit Example[/url]\n[b][i][u][s]All styles[/s][/u][/i][/b] with [color=red][url=https://x.com]Link[/url][/color]\nNo tags, just plain text"
  @FocusState private var isEditorFocused: Bool

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 12) {
          Text("Enter BBCode:")
            .font(.headline)

          ZStack(alignment: .topLeading) {
            TextEditor(text: $input)
              .font(.system(.body, design: .monospaced))
              .frame(minHeight: 160)
              .padding(8)
              .background(Color(.secondarySystemBackground))
              .clipShape(RoundedRectangle(cornerRadius: 8))
              .focused($isEditorFocused)

            if input.isEmpty {
              Text("Type BBCode here…")
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
          }

          Divider()

          Text("Rendered:")
            .font(.headline)

          StyledText(input)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
      }
      .navigationTitle("Styled Text Demo")
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Done") { isEditorFocused = false }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
          Button("Clear") { input = "" }
          Button(isEditorFocused ? "Done" : "Edit") {
            isEditorFocused.toggle()
          }
        }
      }
      .scrollDismissesKeyboard(.interactively)
      .onTapGesture {
        // Dismiss keyboard when tapping outside
        isEditorFocused = false
      }
    }
  }
}

#Preview {
  StyledTextDemo()
}
