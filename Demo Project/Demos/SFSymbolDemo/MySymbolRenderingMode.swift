//
//  MySymbolRenderingMode.swift
//  Demo Project
//
//  Created by John Durcan on 22/10/2025.
//
import SwiftUI


enum MySymbolRenderingMode: Equatable {
  case monochrome
  case hierarchical
  case palette
  case multicolor
  
  var system: SymbolRenderingMode {
    switch self {
    case .monochrome: return .monochrome
    case .hierarchical: return .hierarchical
    case .palette: return .palette
    case .multicolor: return .multicolor
    }
  }
  
  var stringRepresentation: String {
    switch self {
    case .monochrome: return "monochrome"
    case .hierarchical: return "hierarchical"
    case .palette: return "palette"
    case .multicolor: return "multicolor"
    }
  }
}
