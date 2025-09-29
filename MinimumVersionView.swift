//
/*

  Filename: MinimumVersionView.swift
 Project: Demo Project


  Created by John Durcan on 29/09/2025.

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

/*
 Example:

 if #available(iOS 17.0, *) {
 ContentView()
 } else {
 MinimumVersionView(version: 17)
 }

 */

struct MinimumVersionView: View {
  var version: Int

  var body: some View {
    VStack {
      Text("Update Required")
        .font(.title)
        .fontWeight(.bold)
        .padding(.bottom, 10)

      Text("This app requires iOS \(version) or later to run.")
        .font(.body)
        .multilineTextAlignment(.center)
        .padding(.horizontal)

      Spacer()

      Button(action: {
        if let url = URL(string: "https://www.apple.com/ios/") {
          UIApplication.shared.open(url)
        }
      }) {
        Text("Learn About iOS Updates")
          .font(.headline)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
          .padding(.horizontal)
      }
      .padding(.bottom)
    }
    .padding()
  }
}

struct MinimumVersionView_Previews: PreviewProvider {
  static var previews: some View {
    MinimumVersionView(version: 17)
  }
}
