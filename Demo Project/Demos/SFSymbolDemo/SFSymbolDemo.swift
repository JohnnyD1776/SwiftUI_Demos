//
//  SFSymbolDemo.swift
//  Demo Project
//
//  Created by John Durcan on 22/10/2025.
//

import SwiftUI
import SymbolPicker
import Symbols
import UIKit

/**
 Comprehensive SwiftUI-based demo View iOS app (targeting iOS 17+) that demonstrates all major features of SF Symbols, following Apple's Human Interface Guidelines for SF Symbols. It's structured as a single ContentView struct, which serves as the main entry point and UI. The view is designed to be interactive, allowing users to select an SF Symbol, adjust colors and progress values, and explore various display, variant, styling, and animation options. Each demonstration includes a live preview of the symbol and a copyable code snippet for easy reuse.
 Here's a detailed breakdown of the view's structure and components:

 */

struct SFSymbolDemo: View {
    @StateObject private var viewModel = SFSymbolDemoViewModel()

    @State private var showingCodeView = false
    @State private var previewMultipleSymbols = false

    private let previewWidth: CGFloat = 50
    private let previewHeight: CGFloat = 50
    private let previewAlignment: Alignment = .trailing

    enum DemoTab {
        case appearance
        case animation
        case misc
    }

    @State private var currentTab: DemoTab = .appearance

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                sfSymbolPreview
                    .padding()  // Add some breathing room
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemGroupedBackground))
                            .shadow(radius: 2)
                    )
                    .onTapGesture {
                        viewModel.showPicker = true
                    }

                // 2. Tab Selection
                Picker("Mode", selection: $currentTab) {
                    Text("Appearance").tag(DemoTab.appearance)
                    Text("Animation").tag(DemoTab.animation)
                    Text("Misc").tag(DemoTab.misc)
                }
                .pickerStyle(.segmented)
                .padding()

                // 3. Tabbed Form Content
                Form {
                    switch currentTab {
                    case .appearance:
                        Section("Symbol Selection") {
                            // We keep specific selector here if they want list access,
                            // but the hero tap handles picker too.
                            // Let's keep the textual selector just in case.
                            Button {
                                viewModel.showPicker = true
                            } label: {
                                HStack {
                                    Text("Selected Symbol")
                                    Spacer()
                                    Text(viewModel.symbolName).foregroundStyle(.secondary)
                                    Image(systemName: "chevron.right").font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            .buttonStyle(.plain)
                        }

                        Section("Color Controls") {
                            colorSelectors
                        }

                        Section("Variants and Configuration") {
                            basicSelectors
                        }

                        Section("Rendering and Gradients") {
                            OptionSelectorView(
                                title: "Rendering Mode",
                                options: viewModel.renderingOptions.map { ($0.0 ?? nil, $0.1) },
                                selection: $viewModel.selectedRenderingMode)

                            Toggle("Enable Gradient", isOn: $viewModel.enableGradient)

                            if viewModel.enableGradient {
                                Picker("Direction", selection: $viewModel.gradientDirection) {
                                    Text("Top").tag(UnitPoint.top)
                                    Text("Bottom").tag(UnitPoint.bottom)
                                    Text("Leading").tag(UnitPoint.leading)
                                    Text("Trailing").tag(UnitPoint.trailing)
                                    Text("Top Leading").tag(UnitPoint.topLeading)
                                    Text("Bottom Trailing").tag(UnitPoint.bottomTrailing)
                                }
                            }
                        }

                    case .animation:
                        Section("Animations and Effects") {
                            advancedSelectors
                        }

                        Section("Variable Color") {
                            OptionSelectorView(
                                title: "Variable Mode",
                                options: VariableMode.allCases.map { ($0, $0.title) },
                                selection: $viewModel.selectedVariableMode)

                            if viewModel.selectedVariableMode != .none {
                                VStack(alignment: .leading) {
                                    Text(
                                        "Progress: \(viewModel.variableProgress, specifier: "%.2f")"
                                    )
                                    Slider(value: $viewModel.variableProgress, in: 0...1)
                                }

                                if viewModel.selectedVariableMode == .color {
                                    Picker("Style", selection: $viewModel.variableColorStyle) {
                                        ForEach(SFSymbolDemoViewModel.VariableColorStyle.allCases) {
                                            style in
                                            Text(style.rawValue).tag(style)
                                        }
                                    }
                                    .pickerStyle(.segmented)

                                    Toggle("Reversing", isOn: $viewModel.variableColorReversing)
                                    Toggle(
                                        "Hide Inactive Layers",
                                        isOn: $viewModel.variableColorHideInactive)
                                    Toggle("Repeating", isOn: $viewModel.variableColorRepeat)
                                }
                            } else {
                                Text("Select a Variable Mode to configure")
                                    .foregroundStyle(.secondary)
                            }
                        }

                    case .misc:
                        Section("Accessibility and Misc") {
                            VStack(alignment: .leading, spacing: 10) {
                                TextField(
                                    "Accessibility Label", text: $viewModel.accessibilityLabel
                                )
                                .textFieldStyle(.roundedBorder)

                                Text("This label will be read by VoiceOver for the symbol.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("SF Symbols Demo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            showingCodeView = true
                        } label: {
                            Label("Show Code", systemImage: "curlybraces")
                        }

                        Button {
                            UIPasteboard.general.string = viewModel.generateCode()
                        } label: {
                            Label("Copy Code", systemImage: "doc.on.doc")
                        }
                    }
                }
            }
            .alert(isPresented: $showingCodeView) {
                let code = viewModel.generateCode()
                return Alert(
                    title: Text("Generated Code"),
                    message: Text(code).font(.system(.caption, design: .monospaced)),
                    primaryButton: .default(Text("Copy")) {
                        UIPasteboard.general.string = code
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $viewModel.showPicker) {
                SymbolPicker(symbol: $viewModel.symbolName)
            }
        }
    }

    //MARK: View Builders

    var colorSelectors: some View {
        Group {
            ColorPicker("Primary", selection: $viewModel.primaryColor)
            ColorPicker("Secondary", selection: $viewModel.secondaryColor)
            ColorPicker("Tertiary", selection: $viewModel.tertiaryColor)
            ColorPicker("Tint", selection: $viewModel.tintColor)

            // Moved progress slider to Variable section
            // VStack(alignment: .leading) {
            //    Text("Variable Progress: \(viewModel.variableProgress, specifier: "%.2f")")
            //        .font(.caption)
            //        .foregroundStyle(.secondary)
            //    Slider(value: $viewModel.variableProgress, in: 0...1)
            // }
            // .padding(.vertical, 4)
        }
    }

    var basicSelectors: some View {
        Group {
            VStack(alignment: .leading) {
                Text("Variants")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.variantOptions, id: \.0) { variant, title, _ in
                            Toggle(
                                title,
                                isOn: Binding(
                                    get: { viewModel.selectedVariants.contains(variant) },
                                    set: { isSelected in
                                        if isSelected {
                                            viewModel.selectedVariants.append(variant)
                                        } else {
                                            viewModel.selectedVariants.removeAll { $0 == variant }
                                        }
                                    }
                                )
                            )
                            .toggleStyle(.button)
                        }
                    }
                }
            }

            OptionSelectorView(
                title: "Image Scale", options: viewModel.scaleOptions.map { ($0.0, $0.1) },
                selection: $viewModel.selectedImageScale)

            OptionSelectorView(
                title: "Font Weight", options: viewModel.weightOptions.map { ($0.0, $0.1) },
                selection: $viewModel.selectedFontWeight)
        }
    }

    var advancedSelectors: some View {
        Group {
            // Moved Rendering Mode to own section above
            // OptionSelectorView(
            //     title: "Rendering Mode",
            //     options: viewModel.renderingOptions.map { ($0.0 ?? nil, $0.1) },
            //     selection: $viewModel.selectedRenderingMode)

            // Moved Variable Mode to own section
            Picker("Animation", selection: $viewModel.selectedAnimationType) {
                ForEach(AnimationType.allCases) { type in
                    Text(type.title).tag(type)
                }
            }
            .pickerStyle(.menu)

            if viewModel.selectedAnimationType != .none {
                Section(header: Text("Animation Settings")) {
                    // Animation Tuning Controls
                    VStack(alignment: .leading) {
                        Text("Speed: \(String(format: "%.1f", viewModel.animationSpeed))x")
                        Slider(value: $viewModel.animationSpeed, in: 0.1...3.0, step: 0.1)
                    }

                    Stepper(
                        "Repeat: \(viewModel.animationRepeatCount == -1 ? "Indefinite" : "\(viewModel.animationRepeatCount)")",
                        value: $viewModel.animationRepeatCount, in: -1...10)

                    Toggle("Autoreverse", isOn: $viewModel.animationAutoreverse)

                    // Trigger/Active Controls
                    viewModel.selectedAnimationType.controlView(
                        active: $viewModel.animationActive,
                        trigger: $viewModel.animationTrigger
                    )

                    if viewModel.selectedAnimationType.isReplace {
                        Button("Toggle Replace") {
                            withAnimation {
                                viewModel.replaceToggle.toggle()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
    }

    var sfSymbolPreview: some View {
        VStack {
            Toggle("Preview Multiple Symbols", isOn: $previewMultipleSymbols)
                .padding(.horizontal)

            HStack {
                if previewMultipleSymbols {
                    
                    Image(systemName: viewModel.secondarySymbolName)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button("Swap", systemImage: "arrow.triangle.swap") {
                        withAnimation {
                            viewModel.replaceToggle.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                }
                    // The Preview itself
                    buildPreviewView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)
            }
        }
    }

    @ViewBuilder
    func buildBaseImage(symbolName: String = "") -> some View {
        let name = symbolName.isEmpty ? viewModel.symbolName : symbolName
        let variableVal: Double? =
            viewModel.selectedVariableMode != .none ? viewModel.variableProgress : nil

        // Base Image
        let image = Image(systemName: name, variableValue: variableVal)

        let variants = viewModel.selectedVariants
        let finalImage = variants.reduce(AnyView(image)) { currentView, variant in
            AnyView(currentView.symbolVariant(variant))
        }

        let styledImage =
            finalImage
            .imageScale(viewModel.selectedImageScale)
            .font(.largeTitle.weight(viewModel.selectedFontWeight))
            .symbolRenderingMode(viewModel.selectedRenderingMode?.system ?? nil)  // Automatic is nil
            .accessibilityLabel(viewModel.accessibilityLabel)

        applyRenderingStyle(to: styledImage)
    }

    @ViewBuilder
    func applyRenderingStyle<Content: View>(to content: Content) -> some View {
        if viewModel.enableGradient {
            // Gradient Logic
            // We use the selected tint/primary colors to form a gradient
            let colors: [Color] = {
                switch viewModel.selectedRenderingMode {
                case .multicolor, .palette:
                    return [
                        viewModel.primaryColor, viewModel.secondaryColor, viewModel.tertiaryColor,
                    ]
                default:
                    return [viewModel.tintColor, viewModel.tintColor.opacity(0.3)]
                }
            }()

            content.foregroundStyle(
                .linearGradient(
                    Gradient(colors: colors), startPoint: .top,
                    endPoint: viewModel.gradientDirection)
            )
        } else {
            switch viewModel.selectedRenderingMode {
            case nil, .multicolor:
                content
            case .monochrome, .hierarchical:
                content.foregroundStyle(viewModel.tintColor)
            case .palette:
                content.foregroundStyle(
                    viewModel.primaryColor, viewModel.secondaryColor, viewModel.tertiaryColor)
            }
        }
    }

    @ViewBuilder
    func buildPreviewView() -> some View {
        // We determine if we are in "Swap/Replace" mode
        let isSwapping = previewMultipleSymbols || viewModel.selectedAnimationType.isReplace

        if isSwapping {
            // Logic for switching symbols
            let firstSymbol = buildBaseImage(symbolName: viewModel.symbolName)
            let secondSymbol = buildBaseImage(
                symbolName: viewModel.secondarySymbolName.isEmpty
                    ? "\(viewModel.symbolName).fill" : viewModel.secondarySymbolName)

            let content = ZStack {
                if viewModel.replaceToggle {
                    secondSymbol
                } else {
                    firstSymbol
                }
            }

            // Apply transition/animation if selected
            // Note: .contentTransition needs to be on the container of the conditional view (the ZStack)
            // But applyEffect applies modifiers to the content.
            // If animation is .none, we just return content (instant swap).
            // If animation is .replace, applyEffect adds .contentTransition.

            let animatedContent = viewModel.selectedAnimationType.applyEffect(
                to: AnyView(content),
                isActive: viewModel.animationActive,
                trigger: viewModel.animationTrigger,
                speed: viewModel.animationSpeed,
                repeatCount: viewModel.animationRepeatCount == -1
                    ? nil : viewModel.animationRepeatCount,
                autoreverses: viewModel.animationAutoreverse
            )

            HStack {
                viewModel.selectedAnimationType.controlView(
                    active: $viewModel.animationActive,
                    trigger: $viewModel.animationTrigger
                )
                animatedContent
                    .frame(
                        width: previewWidth, height: previewHeight, alignment: previewAlignment)
            }
        } else {
            // Single symbol mode (Variable Color, basic, etc.)
            let baseView = buildBaseImage()

            // Apply Variable Mode Logic
            let variableView: some View = {
                if viewModel.selectedVariableMode == .color {
                    // Logic from before...
                    // Standard .variableColor effect application
                    if #available(iOS 18.0, *) {
                        if viewModel.variableColorStyle == .iterative {
                            if viewModel.variableColorReversing {
                                return AnyView(
                                    baseView.symbolEffect(
                                        .variableColor.iterative,
                                        value: viewModel.variableProgress
                                    )
                                    .symbolEffect(
                                        .variableColor.reversing,
                                        value: viewModel.variableProgress))
                            } else {
                                return AnyView(
                                    baseView.symbolEffect(
                                        .variableColor.iterative,
                                        value: viewModel.variableProgress))
                            }
                        } else {
                            if viewModel.variableColorReversing {
                                return AnyView(
                                    baseView.symbolEffect(
                                        .variableColor.cumulative,
                                        value: viewModel.variableProgress
                                    )
                                    .symbolEffect(
                                        .variableColor.reversing,
                                        value: viewModel.variableProgress))
                            } else {
                                return AnyView(
                                    baseView.symbolEffect(
                                        .variableColor.cumulative,
                                        value: viewModel.variableProgress))
                            }
                        }
                    } else {
                        return AnyView(
                            baseView.symbolEffect(
                                .variableColor, value: viewModel.variableProgress))
                    }
                } else {
                    return AnyView(
                        viewModel.selectedVariableMode.applyMode(
                            to: baseView, value: viewModel.variableProgress))
                }
            }()

            // Apply other animations (Bounce, Pulse, etc.) which are not transitions
            let animatedView = viewModel.selectedAnimationType.applyEffect(
                to: AnyView(variableView),
                isActive: viewModel.animationActive,
                trigger: viewModel.animationTrigger,
                speed: viewModel.animationSpeed,
                repeatCount: viewModel.animationRepeatCount == -1
                    ? nil : viewModel.animationRepeatCount,
                autoreverses: viewModel.animationAutoreverse
            )

            HStack {
                viewModel.selectedAnimationType.controlView(
                    active: $viewModel.animationActive,
                    trigger: $viewModel.animationTrigger
                )
                animatedView
                    .frame(
                        width: previewWidth, height: previewHeight, alignment: previewAlignment)
            }

        }
    }
}

#Preview {
    SFSymbolDemo()
}
