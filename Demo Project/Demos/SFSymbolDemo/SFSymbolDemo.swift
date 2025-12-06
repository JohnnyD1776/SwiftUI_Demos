//
//  SFSymbolDemo.swift
//  Demo Project
//
//  Created by John Durcan on 22/10/2025.
//

import SwiftUI
import SymbolPicker
import UIKit

/**
 Comprehensive SwiftUI-based demo View iOS app (targeting iOS 17+) that demonstrates all major features of SF Symbols, following Apple's Human Interface Guidelines for SF Symbols. It's structured as a single ContentView struct, which serves as the main entry point and UI. The view is designed to be interactive, allowing users to select an SF Symbol, adjust colors and progress values, and explore various display, variant, styling, and animation options. Each demonstration includes a live preview of the symbol and a copyable code snippet for easy reuse.
 Here's a detailed breakdown of the view's structure and components:
 
 */

struct SFSymbolDemo: View {
    @StateObject private var viewModel = SFSymbolDemoViewModel()
    
    @State private var showingCodeView = false
    
    private let previewWidth: CGFloat = 50
    private let previewHeight: CGFloat = 50
    private let previewAlignment: Alignment = .trailing
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                ScrollView {
                    colorSelectors
                    
                    selectors
                }
                .scrollIndicators(.hidden)
                .padding()
                sfSymbolPreview
            }
            .ignoreSafeAreaRespectSensorIsland()
            .alert(isPresented: $showingCodeView) {
                let code = viewModel.generateCode()
                return Alert(title: Text("Code"), message: Text(code)
                    .font(.system(.caption, design: .monospaced))
                             , primaryButton: .default(Text("Copy Code"), action: {
                    UIPasteboard.general.string = code
                }), secondaryButton: .cancel())
            }
            .navigationTitle("SF Symbols Demo (iOS 17+ with iOS 18 Features)")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showPicker) {
                SymbolPicker(symbol: $viewModel.symbolName)
            }
        }
    }
    
    //MARK: View Builders
    
    var symbolSelector: some View {
        Button {
            viewModel.showPicker = true
        } label: {
            buildPreviewView()
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
    
    var colorSelectors: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Color Controls")
                .font(.headline)
            HStack {
                ColorPicker(selection: $viewModel.primaryColor) {
                    Text("Primary")
                }
                ColorPicker(selection: $viewModel.secondaryColor) {
                    Text("Secondary")
                }
                ColorPicker(selection: $viewModel.tertiaryColor) {
                    Text("Tertiary")
                }
            }
            HStack {
                slider
                ColorPicker(selection: $viewModel.tintColor) {
                    Text("Tint")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: 120)
            }
        }
    }
    
    // Variable Progress Slider
    var slider: some View {
        VStack(alignment: .leading) {
            Text("Variable Progress")
                .font(.headline)
            Slider(value: $viewModel.variableProgress, in: 0...1)
        }
        
    }
    
    var selectors: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Selectors")
                .font(.headline)
            
            OptionSelectorView(title: "Variant", options: viewModel.variantOptions.map { ($0.0, $0.1) }, selection: $viewModel.selectedVariant)
            
            OptionSelectorView(title: "Image Scale", options: viewModel.scaleOptions.map { ($0.0, $0.1) }, selection: $viewModel.selectedImageScale)
            
            OptionSelectorView(title: "Font Weight", options: viewModel.weightOptions.map { ($0.0, $0.1) }, selection: $viewModel.selectedFontWeight)
            
            OptionSelectorView(title: "Rendering Mode", options: viewModel.renderingOptions.map { ($0.0 ?? nil, $0.1) }, selection: $viewModel.selectedRenderingMode)
            
            OptionSelectorView(title: "Variable Mode", options: VariableMode.allCases.map { ($0, $0.title) }, selection: $viewModel.selectedVariableMode)
            
            OptionSelectorView(title: "Animation", options: AnimationType.allCases.map { ($0, $0.title) }, selection: $viewModel.selectedAnimationType)
        }
    }
    
    var sfSymbolPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Preview")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: 120, alignment: .leading)
                symbolSelector
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            codeCopyView(code: viewModel.generateCode())
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .padding(.bottom)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    // Code display and copy
    @ViewBuilder
    private func codeCopyView(code: String) -> some View {
        HStack() {
            Button("Copy Code") {
                UIPasteboard.general.string = code
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
            Button("Show Code") {
                showingCodeView = true
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
        }
        
    }
    
    
    @ViewBuilder
    private func buildBaseImage(symbolName: String = "") -> some View {
        let name = symbolName.isEmpty ? viewModel.symbolName : symbolName
        let variableVal: Double? = viewModel.selectedVariableMode != .none ? viewModel.variableProgress : nil
        let baseImage = Image(systemName: name, variableValue: variableVal)
            .symbolVariant(viewModel.selectedVariant)
            .imageScale(viewModel.selectedImageScale)
            .font(.largeTitle.weight(viewModel.selectedFontWeight))
            .symbolRenderingMode(viewModel.selectedRenderingMode?.system ?? nil)
        
        applyRenderingStyle(to: baseImage)
    }
    
    @ViewBuilder
    private func applyRenderingStyle<Content: View>(to content: Content) -> some View {
        switch viewModel.selectedRenderingMode {
        case nil, .multicolor:
            content
        case .monochrome, .hierarchical:
            content.foregroundStyle(viewModel.tintColor)
        case .palette:
            content.foregroundStyle(viewModel.primaryColor, viewModel.secondaryColor, viewModel.tertiaryColor)
        }
    }
    
    @ViewBuilder
    private func buildPreviewView() -> some View {
        let baseView = buildBaseImage()
        let variableView = viewModel.selectedVariableMode.applyMode(to: baseView, value: viewModel.variableProgress)
        let animationType = viewModel.selectedAnimationType
        
        if animationType == .none {
            variableView
        } else if animationType.isReplace {
            let symbolA = viewModel.symbolName
            let symbolB = "\(viewModel.symbolName).fill"
            let currentSymbol = viewModel.animationActive ? symbolB : symbolA
            
            let replaceImage = Image(systemName: currentSymbol)
                .symbolVariant(viewModel.selectedVariant)
                .imageScale(viewModel.selectedImageScale)
                .font(.largeTitle.weight(viewModel.selectedFontWeight))
                .symbolRenderingMode(viewModel.selectedRenderingMode?.system ?? nil)
            
            let styledReplace = applyRenderingStyle(to: replaceImage)
            
            let variableReplace = viewModel.selectedVariableMode.applyMode(to: styledReplace, value: viewModel.variableProgress)
            
            let finalReplace = animationType.applyEffect(to: variableReplace, isActive: viewModel.animationActive, trigger: viewModel.animationTrigger)
            
            HStack {
                animationType.controlView(active: $viewModel.animationActive, trigger: $viewModel.animationTrigger)
                finalReplace
                    .frame(width: previewWidth, height: previewHeight, alignment: previewAlignment)
            }
        } else {
            let animated = animationType.applyEffect(to: variableView, isActive: viewModel.animationActive, trigger: viewModel.animationTrigger)
            
            let symbolView: some View = {
                if animationType.isIOS18 {
                    if #available(iOS 18.0, *) {
                        return AnyView(animated.frame(width: previewWidth, height: previewHeight, alignment: previewAlignment))
                    } else {
                        return AnyView(Text("Available on iOS 18+"))
                    }
                } else {
                    return AnyView(animated.frame(width: previewWidth, height: previewHeight, alignment: previewAlignment))
                }
            }()
            
            let control = animationType.controlView(active: $viewModel.animationActive, trigger: $viewModel.animationTrigger)
            
            let content: some View = {
                Group {
                    control
                    if !animationType.isVisibilityBased || viewModel.animationActive {
                        symbolView
                    }
                }
            }()
            
            if animationType.usesVStack {
                VStack(alignment: .leading) {
                    content
                }
            } else {
                HStack {
                    content
                }
            }
        }
    }
}

#Preview {
    SFSymbolDemo()
}
