//
//  SFSymbolDemoViewModel.swift
//  Demo Project
//
//  Created by John Durcan on 22/10/2025.
//


import Combine
import SwiftUI

class SFSymbolDemoViewModel: ObservableObject {
  @Published var symbolName: String = "pencil"
  @Published var showPicker: Bool = false
  
  // Colors
  @Published var tintColor: Color = .blue
  @Published var primaryColor: Color = .red
  @Published var secondaryColor: Color = .green
  @Published var tertiaryColor: Color = .blue
  
  // For variable color
  @Published var variableProgress: Double = 0.0
  @Published var isVariableColorEnabled: Bool = false
  
  // Selectors
  @Published var selectedVariant: SymbolVariants = .none
  @Published var selectedImageScale: Image.Scale = .large
  @Published var selectedFontWeight: Font.Weight = .regular
  @Published var selectedRenderingMode: MySymbolRenderingMode? = nil
  @Published var selectedAnimationType: AnimationType = .none
  
  // For animations
  @Published var animationTrigger: Int = 0
  @Published var animationActive: Bool = false
  
  
  
  let variantOptions: [(SymbolVariants, String, String)] = [
    (.none, "None", "none"),
    (.fill, "Fill", "fill"),
    (.slash, "Slash", "slash"),
    (.circle, "Circle", "circle"),
    (.square, "Square", "square"),
    (.rectangle, "Rectangle", "rectangle")
  ]
  
  let scaleOptions: [(Image.Scale, String, String)] = [
    (.small, "Small", "small"),
    (.medium, "Medium", "medium"),
    (.large, "Large", "large")
  ]
  
  let weightOptions: [(Font.Weight, String, String)] = [
    (.ultraLight, "Ultra Light", "ultraLight"),
    (.thin, "Thin", "thin"),
    (.light, "Light", "light"),
    (.regular, "Regular", "regular"),
    (.medium, "Medium", "medium"),
    (.semibold, "Semibold", "semibold"),
    (.bold, "Bold", "bold"),
    (.heavy, "Heavy", "heavy"),
    (.black, "Black", "black")
  ]
  
  let renderingOptions: [(MySymbolRenderingMode?, String, String, String)] = [
    (nil, "Default", "nil", ""),
    (.monochrome, "Monochrome", "monochrome", ".foregroundStyle(.blue)"),
    (.hierarchical, "Hierarchical", "hierarchical", ".foregroundStyle(.blue)"),
    (.palette, "Palette", "palette", ".foregroundStyle(.red, .green, .blue)"),
    (.multicolor, "Multicolor", "multicolor", "")
  ]
  
  
  func generateCode() -> String {
    var states = ""
    var imageCode = "Image(systemName: \"\(symbolName)\")"
    
    if let variantTuple = variantOptions.first(where: { $0.0 == selectedVariant }), selectedVariant != .none {
      imageCode += "\n    .symbolVariant(.\(variantTuple.2))"
    }
    
    if let scaleTuple = scaleOptions.first(where: { $0.0 == selectedImageScale }), selectedImageScale != .medium {
      imageCode += "\n    .imageScale(.\(scaleTuple.2))"
    }
    
    let weightName = weightOptions.first(where: { $0.0 == selectedFontWeight })?.2 ?? "regular"
    imageCode += "\n    .font(.largeTitle.weight(.\(weightName)))"
    
    if let renderingTuple = renderingOptions.first(where: { $0.0 == selectedRenderingMode }) {
      if let mode = selectedRenderingMode {
        imageCode += "\n    .symbolRenderingMode(.\(mode.stringRepresentation))"
      }
      if !renderingTuple.3.isEmpty {
        imageCode += "\n    \(renderingTuple.3)"
      }
    }
    
    if isVariableColorEnabled {
      imageCode += "\n    .symbolEffect(.variableColor, value: \(variableProgress))  // 0...1"
    }
    
    let animation = selectedAnimationType
    if animation != .none {
      if let stateCode = animation.stateDeclarationCode {
        states += stateCode + "\n"
      }
      states += animation.additionalStates(symbolName: symbolName)
      
      if animation.isReplace {
        imageCode = animation.wrapImageCode(imageCode)
        imageCode += "\n    .font(.largeTitle)"
        if let renderingTuple = renderingOptions.first(where: { $0.0 == selectedRenderingMode }), !renderingTuple.3.isEmpty {
          imageCode += "\n    \(renderingTuple.3)"
        }
      } else {
        imageCode = animation.wrapImageCode(imageCode)
      }
      
      if let effectCode = animation.effectModifierCode {
        imageCode += "\n    \(effectCode)"
      }
      
      if let comment = animation.comment {
        imageCode += "\n\n\(comment)"
      }
    }
    
    return states + imageCode
  }
}
