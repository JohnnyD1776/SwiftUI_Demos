//
/*

  Filename: GameOverView.swift
 Project: Flappy Builder


  Created by John Durcan on 08/10/2025.

  Copyright © 2025 Itch Studio Ltd.. All rights reserved.

  Company No. 14729010. Registered Address: 128, City Road, London, EC1V 2NX 

All rights reserved. This software and associated documentation files (the "Software") are proprietary and confidential to Itch Studio Ltd. No part of the Software may be reproduced, distributed, modified, or used in any manner without prior written permission from Itch Studio Ltd., except as permitted by applicable law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL ITCH STUDIO LTD. BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  File Description:
  
*/
import SwiftUI





struct GameOverView: View {
  let score: Int // Added score parameter
  let onReset: () -> Void
  @State private var scale: CGFloat = 0.5 // Initial scale for animation
  @State private var opacity: Double = 0.0 // Initial opacity for animation

  var body: some View {
    ZStack {
      Color.black.opacity(0.5)
        .ignoresSafeArea()
      VStack {
        Text("Game Over")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding()
        Text("Score: \(score)")
          .font(.title2)
          .foregroundColor(.white)
          .padding(.bottom)
        Button(action: onReset) {
          Text("Try Again")
            .font(.title2)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
      }
      .padding()
      .background(Color.gray.opacity(0.8))
      .cornerRadius(20)
      .scaleEffect(scale) // Apply scale animation
      .opacity(opacity) // Apply fade animation
      .onAppear {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
          scale = 1.0 // Scale up to normal size
          opacity = 1.0 // Fade in
        }
      }
    }
  }
}
