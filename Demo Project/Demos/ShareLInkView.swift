//
/*

  Filename: ShareLInkView.swift
 Project: Demo Project


  Created by John Durcan on 11/10/2025.

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

struct ShareLInkView: View {
  let siteURL = URL(string: "https://itch.studio")!
  let siteDescription = "Itch Studio: UK-based agency creating innovative iOS and Android apps that inspire."

  // Placeholder images/icons for previews - To use SystemImages must first be rendered as a UIImage to be passed in as a concrete Image.
  let previewImage = Image("ShareLInkViewImage") // Must be in Assets Catalog. systemImages do not appear to work
  let previewIcon = Image(uiImage: UIImage(systemName: "app.gift")!)

  // Multiple URLs for demo
  let multipleURLs = [
    URL(string: "https://itch.studio")!,
    URL(string: "https://developer.apple.com/swiftui")!
  ]

  var body: some View {
    NavigationStack {
      List {
        Section("Basic ShareLink Examples (iOS 16+)") {
          // 1. Basic ShareLink
          VStack(alignment: .leading, spacing: 8) {
            Text("1. Basic URL Share")
              .font(.headline)
            Text("Expected outcome: Opens share sheet with default URL preview showing the link as clickable text.")
            ShareLink(item: siteURL) {
              Label("Share Site URL", systemImage: "square.and.arrow.up")
            }
          }
          .padding(.vertical, 4)

          // 2. Title-Only Preview
          VStack(alignment: .leading, spacing: 8) {
            Text("2. Custom Title Preview")
              .font(.headline)
            Text("Expected outcome: Share sheet preview shows custom title 'Itch Studio' without image or icon.")
            ShareLink(
              item: siteURL,
              preview: SharePreview("Itch Studio")
            ) {
              Label("Share with Title", systemImage: "bookmark")
            }
          }
          .padding(.vertical, 4)

          // 3. Title + Image Preview
          VStack(alignment: .leading, spacing: 8) {
            Text("3. Title + Image Preview")
              .font(.headline)
            Text("Expected outcome: Preview includes title and thumbnail image for visual app context.")
            ShareLink(
              item: siteURL,
              preview: SharePreview(siteDescription, image: previewImage)
            ) {
              Label("Share with Image", systemImage: "photo")
            }
          }
          .padding(.vertical, 4)

          // 4. Title + Icon Preview
          VStack(alignment: .leading, spacing: 8) {
            Text("4. Title + Icon Preview")
              .font(.headline)
            Text("Expected outcome: Preview shows title with small app gift icon as a badge.")
            ShareLink(
              item: siteURL,
              preview: SharePreview(siteDescription, icon: previewIcon)
            ) {
              Label("Share with Icon", systemImage: "app")
            }
          }
          .padding(.vertical, 4)

          // 5. Full Preview (Title + Image + Icon)
          VStack(alignment: .leading, spacing: 8) {
            Text("5. Full Preview (Title + Image + Icon)")
              .font(.headline)
            Text("Expected outcome: Rich preview with title, large image thumbnail, and app icon badge.")
            ShareLink(
              item: siteURL,
              preview: SharePreview(siteDescription, image: previewImage, icon: previewIcon)
            ) {
              Label("Share Full Preview", systemImage: "square.and.arrow.up")
            }
          }
          .padding(.vertical, 4)

          // 6. Multiple Items
          VStack(alignment: .leading, spacing: 8) {
            Text("6. Multiple Items")
              .font(.headline)
            Text("Expected outcome: Shares array of URLs; sheet combines them with individual title previews.")
            ShareLink(
              items: multipleURLs,
              preview: { url in
                SharePreview(url.absoluteString)
              }
            ) {
              Label("Share Multiple URLs", systemImage: "link")
            }
          }
          .padding(.vertical, 4)

          // 7. With Subject and Message
          VStack(alignment: .leading, spacing: 8) {
            Text("7. With Subject and Message")
              .font(.headline)
            Text("Expected outcome: Pre-populates subject/message in apps like Mail/Messages; includes title preview.")
            ShareLink(
              item: siteURL,
              subject: Text("Discover Itch Studio"),
              message: Text("Check out this innovative app development agency!"),
              preview: SharePreview(siteDescription)
            ) {
              Label("Share with Message", systemImage: "envelope")
            }
          }
          .padding(.vertical, 4)
        }

        Section("ShareLink Styles (iOS 17+)") {
          Text("iOS 17+ Required")
            .font(.caption)
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)

          // 8a. Automatic Style
          VStack(alignment: .leading, spacing: 8) {
            Text("8a. Default Appearance")
              .font(.headline)
            Text("Expected outcome: Standard ShareLink button with label and icon; preview shows site description.")
            ShareLink(
              item: siteURL,
              preview: SharePreview(siteDescription)
            ) {
              Label("Default", systemImage: "square.and.arrow.up")
            }
          }
          .padding(.vertical, 4)

          // 8b. Icon-Only Appearance
          HStack {
            VStack(alignment: .leading, spacing: 8) {
              Text("8b. Icon-Only Appearance")
                .font(.headline)
              Text("Expected outcome: Compact icon-only button using custom label, ideal for toolbars.")
            }
            Spacer()
            ShareLink(
              item: siteURL,
              preview: SharePreview(siteDescription)
            ) {
              Image(systemName: "square.and.arrow.up")
            }
          }
          .padding(.vertical, 4)

          // 8c. Large Icon Appearance
          HStack {
            VStack(alignment: .leading, spacing: 8) {
              Text("8c. Large Icon Appearance")
                .font(.headline)
              Text("Expected outcome: Prominent button with large icon using .font(.largeTitle) modifier.")
            }
            Spacer()
            ShareLink(
              item: siteURL,
              preview: SharePreview(siteDescription)
            ) {
              Image(systemName: "square.and.arrow.up")
                .font(.largeTitle)
            }
          }
          .padding(.vertical, 4)        }
      }
      .navigationTitle("ShareLink Demo")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

#Preview {
  ShareLInkView()
}


