//
//  AnimationType.swift
//  Demo Project
//
//  Created by John Durcan on 22/10/2025.
//
import SwiftUI


enum AnimationType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case none
    case bounce, bounceUp, bounceDown
    case pulse, pulseByLayer
    case scale, scaleUp, scaleDown
    case variableColorIterative, variableColorCumulative, variableColorIterativeReversing
    case breathe, rotateClockwise, rotateCounterclockwise, wiggleSway, wiggleRattle
    case appear, disappear, replace
    case drawOn, drawOff, magicReplace
    
    var title: String {
        switch self {
        case .none: return "None"
        case .bounce: return "Bounce (Trigger)"
        case .bounceUp: return "Bounce Up (Trigger)"
        case .bounceDown: return "Bounce Down (Trigger)"
        case .pulse: return "Pulse (Toggle)"
        case .pulseByLayer: return "Pulse By Layer (Toggle)"
        case .scale: return "Scale (Toggle)"
        case .scaleUp: return "Scale Up (Toggle)"
        case .scaleDown: return "Scale Down (Toggle)"
        case .variableColorIterative: return "Variable Color Iterative (Toggle)"
        case .variableColorCumulative: return "Variable Color Cumulative (Toggle)"
        case .variableColorIterativeReversing: return "Variable Color Iterative Reversed (Toggle)"
        case .breathe: return "Breathe (Toggle)"
        case .rotateClockwise: return "Rotate Clockwise (Toggle)"
        case .rotateCounterclockwise: return "Rotate Counterclockwise (Toggle)"
        case .wiggleSway: return "Wiggle Sway (Toggle)"
        case .wiggleRattle: return "Wiggle Rattle (Toggle)"
        case .appear: return "Appear (Toggle Visibility)"
        case .disappear: return "Disappear (Toggle Visibility)"
        case .replace: return "Replace (Toggle Between Symbols)"
        case .drawOn: return "Draw On (Toggle Visibility, iOS 18+)"
        case .drawOff: return "Draw Off (Toggle Visibility, iOS 18+)"
        case .magicReplace: return "Magic Replace (Toggle Between Symbols, iOS 18+)"
        }
    }
    
    var effectCode: String {
        switch self {
        case .bounce: return ".bounce"
        case .bounceUp: return ".bounce.up"
        case .bounceDown: return ".bounce.down"
        case .pulse: return ".pulse, options: .repeating"
        case .pulseByLayer: return ".pulse.byLayer, options: .repeating"
        case .scale: return ".scale"
        case .scaleUp: return ".scale.up"
        case .scaleDown: return ".scale.down"
        case .variableColorIterative: return ".variableColor.iterative, options: .repeating"
        case .variableColorCumulative: return ".variableColor.cumulative, options: .repeating"
        case .variableColorIterativeReversing: return ".variableColor.iterative.reversing, options: .repeating"
        case .breathe: return ".breathe, options: .repeating"
        case .rotateClockwise: return ".rotate.clockwise, options: .repeating"
        case .rotateCounterclockwise: return ".rotate.counterclockwise, options: .repeating"
        case .wiggleSway: return ".wiggle.sway, options: .repeating"
        case .wiggleRattle: return ".wiggle.rattle, options: .repeating"
        case .appear: return ".appear"
        case .disappear: return ".disappear"
        case .replace: return ".replace"
        case .drawOn: return ".drawOn.byLayer"
        case .drawOff: return ".drawOff.byLayer"
        case .magicReplace: return ".replace.magic(fallback: .downUp.byLayer), options: .nonRepeating"
        case .none: return ""
        }
    }
    
    var isDiscrete: Bool {
        switch self {
        case .bounce, .bounceUp, .bounceDown: return true
        default: return false
        }
    }
    
    var isIndefinite: Bool {
        switch self {
        case .pulse, .pulseByLayer, .scale, .scaleUp, .scaleDown, .variableColorIterative, .variableColorCumulative, .variableColorIterativeReversing, .breathe, .rotateClockwise, .rotateCounterclockwise, .wiggleSway, .wiggleRattle: return true
        default: return false
        }
    }
    
    var isVisibilityBased: Bool {
        switch self {
        case .appear, .disappear, .drawOn, .drawOff: return true
        default: return false
        }
    }
    
    var isReplace: Bool {
        switch self {
        case .replace, .magicReplace: return true
        default: return false
        }
    }
    
    var requiredRendering: MySymbolRenderingMode? {
        switch self {
        case .variableColorIterative, .variableColorCumulative, .variableColorIterativeReversing: return .hierarchical
        default: return nil
        }
    }
    
    var isIOS18: Bool {
        switch self {
        case .breathe, .rotateClockwise, .rotateCounterclockwise, .wiggleSway, .wiggleRattle, .drawOn, .drawOff, .magicReplace: return true
        default: return false
        }
    }
    
    // New refactored properties and methods
    
    var controlLabel: String {
        switch self {
        case .none: return ""
        case .bounce, .bounceUp, .bounceDown: return "Trigger"
        case .appear, .disappear, .drawOn, .drawOff: return "Show"
        case .replace, .magicReplace: return "Replace"
        default: return "Active"
        }
    }
    
    var usesButton: Bool {
        isDiscrete
    }
    
    var usesToggle: Bool {
        !isDiscrete && self != .none
    }
    
    var usesVStack: Bool {
        isVisibilityBased
    }
    
    @ViewBuilder
    func applyEffect<T: View>(to content: T, isActive: Bool, trigger: Int) -> some View {
        switch self {
        case .none:
            content
        case .bounce:
            content.symbolEffect(.bounce, value: trigger)
        case .bounceUp:
            content.symbolEffect(.bounce.up, value: trigger)
        case .bounceDown:
            content.symbolEffect(.bounce.down, value: trigger)
        case .pulse:
            content.symbolEffect(.pulse, options: .repeating, isActive: isActive)
        case .pulseByLayer:
            content.symbolEffect(.pulse.byLayer, options: .repeating, isActive: isActive)
        case .scale:
            content.symbolEffect(.scale, isActive: isActive)
        case .scaleUp:
            content.symbolEffect(.scale.up, isActive: isActive)
        case .scaleDown:
            content.symbolEffect(.scale.down, isActive: isActive)
        case .variableColorIterative:
            content.symbolEffect(.variableColor.iterative, options: .repeating, isActive: isActive)
        case .variableColorCumulative:
            content.symbolEffect(.variableColor.cumulative, options: .repeating, isActive: isActive)
        case .variableColorIterativeReversing:
            content.symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: isActive)
        case .breathe:
            content.symbolEffect(.breathe, options: .repeating, isActive: isActive)
        case .rotateClockwise:
            content.symbolEffect(.rotate.clockwise, options: .repeating, isActive: isActive)
        case .rotateCounterclockwise:
            content.symbolEffect(.rotate.counterClockwise, options: .repeating, isActive: isActive)
        case .wiggleSway:
            if #available(iOS 18.0, *) {
                content.symbolEffect(.wiggle.backward, options: .repeating, isActive: isActive)
            } else {
                content
            }
        case .wiggleRattle:
            if #available(iOS 18.0, *) {
                content.symbolEffect(.wiggle.right, options: .repeating, isActive: isActive)
            } else {
                content
            }
        case .appear:
            content.symbolEffect(.appear)
        case .disappear:
            content.symbolEffect(.disappear)
        case .replace:
            content.contentTransition(.symbolEffect(.replace))
        case .drawOn:
            if #available(iOS 26.0, *) {
                content.transition(.symbolEffect(.drawOn.byLayer))
            } else {
                content
            }
        case .drawOff:
            if #available(iOS 26.0, *) {
                content.transition(.symbolEffect(.drawOff.byLayer))
            } else {
                content
            }
        case .magicReplace:
            if #available(iOS 18.0, *) {
                content.contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
            } else {
                content
            }
        }
    }
    
    @ViewBuilder
    func controlView(active: Binding<Bool>, trigger: Binding<Int>) -> some View {
        if usesButton {
            Button(controlLabel) {
                trigger.wrappedValue += 1
            }
            .buttonStyle(.borderedProminent)
        } else if usesToggle {
            Toggle(controlLabel, isOn: active)
        }
    }
    
    var stateDeclarationCode: String? {
        switch self {
        case .none:
            return nil
        case .bounce, .bounceUp, .bounceDown:
            return "@State private var animationTrigger: Int = 0"
        case .pulse, .pulseByLayer, .scale, .scaleUp, .scaleDown, .variableColorIterative, .variableColorCumulative, .variableColorIterativeReversing, .breathe, .rotateClockwise, .rotateCounterclockwise, .wiggleSway, .wiggleRattle:
            return "@State private var isActive: Bool = false"
        case .appear, .disappear, .drawOn, .drawOff:
            return "@State private var show: Bool = true"
        case .replace, .magicReplace:
            return "@State private var replaceToggle: Bool = false"
        }
    }
    
    func additionalStates(symbolName: String) -> String {
        switch self {
        case .replace, .magicReplace:
            return "let symbolA = \"\(symbolName)\"\nlet symbolB = \"\(symbolName).fill\""
        default:
            return ""
        }
    }
    
    var effectModifierCode: String? {
        switch self {
        case .none:
            return nil
        case .bounce, .bounceUp, .bounceDown:
            return ".symbolEffect(\(effectCode), value: animationTrigger)"
        case .pulse, .pulseByLayer, .scale, .scaleUp, .scaleDown, .variableColorIterative, .variableColorCumulative, .variableColorIterativeReversing, .breathe, .rotateClockwise, .rotateCounterclockwise, .wiggleSway, .wiggleRattle:
            return ".symbolEffect(\(effectCode), isActive: isActive)"
        case .appear, .disappear:
            return ".symbolEffect(\(effectCode))"
        case .replace, .magicReplace:
            return ".contentTransition(.symbolEffect(\(effectCode)))"
        case .drawOn, .drawOff:
            return ".transition(.symbolEffect(\(effectCode)))"
        }
    }
    
    func wrapImageCode(_ code: String) -> String {
        switch self {
        case .appear, .disappear, .drawOn, .drawOff:
            return "if show {\n    \(code)\n}"
        case .replace, .magicReplace:
            return "Image(systemName: replaceToggle ? symbolB : symbolA)"
        default:
            return code
        }
    }
    
    var comment: String? {
        switch self {
        case .bounce, .bounceUp, .bounceDown:
            return "// Increment animationTrigger to trigger"
        case .appear, .disappear, .drawOn, .drawOff:
            return "// Toggle show to see the effect"
        case .replace, .magicReplace:
            return "// Toggle replaceToggle to see the effect"
        default:
            return nil
        }
    }
}
