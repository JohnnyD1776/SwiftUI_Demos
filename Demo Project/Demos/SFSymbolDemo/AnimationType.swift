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
        case .variableColorIterativeReversing:
            return ".variableColor.iterative.reversing, options: .repeating"
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
        case .magicReplace:
            return ".replace.magic(fallback: .downUp.byLayer), options: .nonRepeating"
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
        case .pulse, .pulseByLayer, .scale, .scaleUp, .scaleDown, .variableColorIterative,
            .variableColorCumulative, .variableColorIterativeReversing, .breathe, .rotateClockwise,
            .rotateCounterclockwise, .wiggleSway, .wiggleRattle:
            return true
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
        case .variableColorIterative, .variableColorCumulative, .variableColorIterativeReversing:
            return .hierarchical
        default: return nil
        }
    }

    var isIOS18: Bool {
        switch self {
        case .breathe, .rotateClockwise, .rotateCounterclockwise, .wiggleSway, .wiggleRattle,
            .drawOn, .drawOff, .magicReplace:
            return true
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
        !isDiscrete && self != .none && !isReplace
    }

    var usesVStack: Bool {
        isVisibilityBased
    }

    @ViewBuilder
    func applyEffect<T: View>(
        to content: T, isActive: Bool, trigger: Int, speed: Double = 1.0, repeatCount: Int? = nil,
        autoreverses: Bool = false
    ) -> some View {
        // Construct options based on parameters
        // Note: SwiftUI's .symbolEffect options are composable but types can be tricky.
        // We will stick to the most common pattern or just apply the modifier directly.
        // For speed, we use .speed(speed) on the view *after* the effect? No, typical animation speed is controlled by the effect or transaction.
        // Actually, SymbolEffect has a .speed modifier in some contexts or we use the View .symbolEffect(..., options: .speed(x))

        // Let's simplified: We will apply .symbolEffect(..., options: ...)
        // We need to construct the SymbolEffectOptions.
        // Since we can't easily dynamically build SymbolEffectOptions struct in a switch without returning opaque types or AnyView mess,
        // we'll try to apply distinct modifiers if needed or hardcode the common "Repeating" option.

        // BUT, we want to support user defined repetition.
        // .repeating, .nonRepeating, .repeat(count)

        // Helper to get options
        /*
         We can't easily return `SymbolEffectOptions` because it's a protocol or struct that changes?
         Actually it is `SymbolEffectOptions`.
         Let's try to just use the parameters inside the switch.
         */

        let repeatOption: SymbolEffectOptions = {
            if let count = repeatCount {
                return .repeat(count)
            } else {
                return .repeating  // Default for "indefinite" or basic cases? Or maybe .nonRepeating?
                // If ID is indefinite, we likely want repeating.
            }
        }()

        let finalOptions: SymbolEffectOptions = repeatOption.speed(speed)

        // WARNING: .autoreverses is not directly on SymbolEffectOptions in all versions, or it is part of the effect definition (.up/down).
        // Actually .repeating has a default behavior.

        switch self {
        case .none:
            content
        case .bounce:
            content.symbolEffect(.bounce, options: finalOptions, value: trigger)
        case .bounceUp:
            content.symbolEffect(.bounce.up, options: finalOptions, value: trigger)
        case .bounceDown:
            content.symbolEffect(.bounce.down, options: finalOptions, value: trigger)
        case .pulse:
            content.symbolEffect(.pulse, options: finalOptions, isActive: isActive)
        case .pulseByLayer:
            content.symbolEffect(.pulse.byLayer, options: finalOptions, isActive: isActive)
        case .scale:
            content.symbolEffect(.scale, options: finalOptions, isActive: isActive)
        case .scaleUp:
            content.symbolEffect(.scale.up, options: finalOptions, isActive: isActive)
        case .scaleDown:
            content.symbolEffect(.scale.down, options: finalOptions, isActive: isActive)
        case .variableColorIterative:
            content.symbolEffect(
                .variableColor.iterative, options: finalOptions, isActive: isActive)
        case .variableColorCumulative:
            content.symbolEffect(
                .variableColor.cumulative, options: finalOptions, isActive: isActive)
        case .variableColorIterativeReversing:
            // Reversing is part of the effect style, not the options usually.
            content.symbolEffect(
                .variableColor.iterative.reversing, options: finalOptions, isActive: isActive)
        case .breathe:
            content.symbolEffect(.breathe, options: finalOptions, isActive: isActive)
        case .rotateClockwise:
            content.symbolEffect(.rotate.clockwise, options: finalOptions, isActive: isActive)
        case .rotateCounterclockwise:
            content.symbolEffect(
                .rotate.counterClockwise, options: finalOptions, isActive: isActive)
        case .wiggleSway:
            if #available(iOS 18.0, *) {
                content.symbolEffect(.wiggle.backward, options: finalOptions, isActive: isActive)
            } else {
                content
            }
        case .wiggleRattle:
            if #available(iOS 18.0, *) {
                content.symbolEffect(.wiggle.right, options: finalOptions, isActive: isActive)
            } else {
                content
            }
        case .appear:
            content.symbolEffect(.appear, options: finalOptions)
        case .disappear:
            content.symbolEffect(.disappear, options: finalOptions)
        case .replace:
            content.contentTransition(.symbolEffect(.replace, options: finalOptions))
        case .drawOn:
            if #available(iOS 26.0, *) {
                content.transition(.symbolEffect(.drawOn, options: finalOptions))
            } else {
                content
            }
        case .drawOff:
            if #available(iOS 26.0, *) {
                content.transition(.symbolEffect(.drawOff, options: finalOptions))
            } else {
                content
            }
        case .magicReplace:
            if #available(iOS 18.0, *) {
                content.contentTransition(
                    .symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: finalOptions))
            } else {
                // Fallback to standard replace for iOS 17
                content.contentTransition(.symbolEffect(.replace, options: finalOptions))
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
        case .pulse, .pulseByLayer, .scale, .scaleUp, .scaleDown, .variableColorIterative,
            .variableColorCumulative, .variableColorIterativeReversing, .breathe, .rotateClockwise,
            .rotateCounterclockwise, .wiggleSway, .wiggleRattle:
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
        case .pulse, .pulseByLayer, .scale, .scaleUp, .scaleDown, .variableColorIterative,
            .variableColorCumulative, .variableColorIterativeReversing, .breathe, .rotateClockwise,
            .rotateCounterclockwise, .wiggleSway, .wiggleRattle:
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
