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

    // Gradients
    @Published var enableGradient: Bool = false
    @Published var gradientDirection: UnitPoint = .top

    // For variable
    @Published var variableProgress: Double = 0.0
    @Published var selectedVariableMode: VariableMode = .none

    // Variable Color Options
    enum VariableColorStyle: String, CaseIterable, Identifiable {
        case cumulative = "Cumulative"
        case iterative = "Iterative"
        var id: String { rawValue }
    }
    @Published var variableColorStyle: VariableColorStyle = .cumulative
    @Published var variableColorReversing: Bool = false
    @Published var variableColorHideInactive: Bool = false
    @Published var variableColorRepeat: Bool = true

    // MARK: - Animation State
    @Published var selectedAnimationType: AnimationType = .none
    @Published var animationTrigger: Int = 0
    @Published var animationActive: Bool = false
    @Published var replaceToggle: Bool = false  // For replace effects

    // Animation Tuning
    @Published var animationSpeed: Double = 1.0
    @Published var animationRepeatCount: Int = 1  // 0 = non-repeating, 1+ = count, -1 = indefinite
    @Published var animationAutoreverse: Bool = false

    @Published var secondarySymbolName: String = "star.fill"  // For replace transitions
    @Published var accessibilityLabel: String = ""

    // Selectors
    @Published var selectedVariants: [SymbolVariants] = []
    @Published var selectedImageScale: Image.Scale = .large
    @Published var selectedFontWeight: Font.Weight = .regular
    @Published var selectedRenderingMode: MySymbolRenderingMode? = nil

    let variantOptions: [(SymbolVariants, String, String)] = [
        (.fill, "Fill", "fill"),
        (.slash, "Slash", "slash"),
        (.circle, "Circle", "circle"),
        (.square, "Square", "square"),
        (.rectangle, "Rectangle", "rectangle"),
    ]

    let scaleOptions: [(Image.Scale, String, String)] = [
        (.small, "Small", "small"),
        (.medium, "Medium", "medium"),
        (.large, "Large", "large"),
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
        (.black, "Black", "black"),
    ]

    let renderingOptions: [(MySymbolRenderingMode?, String, String, String)] = [
        (nil, "Automatic", "nil", ""),
        (.monochrome, "Monochrome", "monochrome", ".foregroundStyle(.blue)"),
        (.hierarchical, "Hierarchical", "hierarchical", ".foregroundStyle(.blue)"),
        (.palette, "Palette", "palette", ".foregroundStyle(.red, .green, .blue)"),
        (.multicolor, "Multicolor", "multicolor", ""),
    ]

    func generateCode() -> String {
        var states = ""
        var imageCode = "Image(systemName: \"\(symbolName)\")"

        let hasVariable = selectedVariableMode != .none
        if hasVariable {
            imageCode =
                "Image(systemName: \"\(symbolName)\", variableValue: progress)  // progress ranges from 0...1"
        } else {
            imageCode = "Image(systemName: \"\(symbolName)\")"
        }

        for variant in selectedVariants {
            if let variantTuple = variantOptions.first(where: { $0.0 == variant }) {
                imageCode += "\n    .symbolVariant(.\(variantTuple.2))"
            }
        }

        if let scaleTuple = scaleOptions.first(where: { $0.0 == selectedImageScale }),
            selectedImageScale != .medium
        {
            imageCode += "\n    .imageScale(.\(scaleTuple.2))"
        }

        let weightName = weightOptions.first(where: { $0.0 == selectedFontWeight })?.2 ?? "regular"
        imageCode += "\n    .font(.largeTitle.weight(.\(weightName)))"

        if let renderingTuple = renderingOptions.first(where: { $0.0 == selectedRenderingMode }) {
            if let mode = selectedRenderingMode {
                imageCode += "\n    .symbolRenderingMode(.\(mode.stringRepresentation))"
            }
            // For Automatic (nil), we don't add .symbolRenderingMode unless we want to be explicit, but usually we don't.
            // If the user selects a specific mode that requires styles (like palette), adding the styles:
            if !renderingTuple.3.isEmpty && !enableGradient {
                imageCode += "\n    \(renderingTuple.3)"
            }
        }

        if enableGradient {
            // dynamic gradient generation
            var startPoint = ".top"
            var endPoint = ".bottom"

            // Map UnitPoint to string (simplified for common cases)
            switch gradientDirection {
            case .top:
                endPoint = ".top"
                startPoint = ".bottom"  // Inverted logic in my head vs SwiftUI? standard gradient is usually top to bottom.
                // Wait, if direction is .top, does that mean "to top"? Usually linearGradient(gradient, startPoint, endPoint).
                // Let's assume the user selection 'gradientDirection' maps to 'endPoint'.
                endPoint = ".top"
                startPoint = ".bottom"
            case .bottom:
                endPoint = ".bottom"
                startPoint = ".top"
            case .leading:
                endPoint = ".leading"
                startPoint = ".trailing"
            case .trailing:
                endPoint = ".trailing"
                startPoint = ".leading"
            case .topLeading:
                endPoint = ".topLeading"
                startPoint = ".bottomTrailing"
            case .bottomTrailing:
                endPoint = ".bottomTrailing"
                startPoint = ".topLeading"
            default: break
            }

            imageCode +=
                "\n    .foregroundStyle(.linearGradient(Gradient(colors: [.primary, .secondary]), startPoint: \(startPoint), endPoint: \(endPoint)))"
        }

        if selectedVariableMode != .none {
            if selectedVariableMode == .color {
                // Enhanced Variable Color Code
                var options = ""
                if variableColorStyle == .iterative {
                    options += ".iterative"
                } else {
                    options += ".cumulative"
                }
                if variableColorReversing { options += ".reversing" }
                if variableColorHideInactive { options += ".hideInactiveLayers" }
                if !variableColorRepeat { options += ".nonRepeating" }

                imageCode += "\n    .symbolEffect(.variableColor(\(options)), value: progress)"
            } else {
                imageCode += "\n    \(selectedVariableMode.code)"
            }
        }

        let animation = selectedAnimationType
        if animation != .none {
            var optionsCode = ""
            if animationSpeed != 1.0 {
                optionsCode += ".speed(\(String(format: "%.1f", animationSpeed)))"
            }
            if animationRepeatCount == -1 {
                optionsCode += ".repeating"
            } else if animationRepeatCount > 0 {
                optionsCode += ".repeat(\(animationRepeatCount))"
            }
            if animationAutoreverse {
                optionsCode += ".autoreverse(true)"
            }

            if let stateCode = animation.stateDeclarationCode {
                states += stateCode + "\n"
            }
            states += animation.additionalStates(symbolName: symbolName)

            if animation.isReplace {
                imageCode = animation.wrapImageCode(imageCode)
                imageCode += "\n    .font(.largeTitle)"
                if let renderingTuple = renderingOptions.first(where: {
                    $0.0 == selectedRenderingMode
                }), !renderingTuple.3.isEmpty {
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

        if hasVariable {
            imageCode += "\n    #if os(iOS) && swift(>=6.0) // or #available(iOS 18.0, *)"
            imageCode += "\n    .symbolVariableValueMode(.\(selectedVariableMode.rawValue))"
            imageCode += "\n    #endif"
        }

        if !accessibilityLabel.isEmpty {
            imageCode += "\n    .accessibilityLabel(\"\(accessibilityLabel)\")"
        }

        return states + imageCode
    }
}
