//
//  OptionSelectorView.swift
//  Demo Project
//
//  Created by John Durcan on 22/10/2025.
//
import SwiftUI

struct OptionSelectorView<Value: Hashable & Equatable>: View {
  let title: String
  let options: [(Value, String)]
  @Binding var selection: Value
  
  var body: some View {
    if options.count <= 3 {
      Picker(title, selection: $selection) {
        ForEach(options, id: \.0) { value, label in
          Text(label).tag(value)
        }
      }
      .pickerStyle(.segmented)
    } else {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 0) {
          ForEach(options, id: \.0) { value, label in
            Button {
              selection = value
            } label: {
              Text(label)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(selection == value ? Color.accentColor : Color.clear)
                .foregroundColor(selection == value ? .white : .primary)
            }
            .buttonStyle(.plain)
            
            if value != options.last?.0 {
              Divider()
                .frame(height: 20)
            }
          }
        }
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
    }
  }
}
