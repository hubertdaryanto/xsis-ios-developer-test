//
//  SearchView.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import SwiftUI

struct SearchBar: View {
    let searchLabel: String
    @Binding var text: String
    @State private var isEditing = false
    
    var searchButtonAction: () -> Void = {}
    
    var body: some View {
        HStack {
            TextField(searchLabel, text: $text) { startedEditing in
                if startedEditing {
                    withAnimation {
                        isEditing = true
                    }
                }
            } onCommit: {
                withAnimation {
                    isEditing = false
                }
                
                if !text.isEmpty {
                    searchButtonAction()
                }
            }
            .font(.body)
            .foregroundColor(Color(red: 0.62, green: 0.67, blue: 0.69))
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .cornerRadius(8)
            .keyboardType(UIKeyboardType.alphabet)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if isEditing {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal, 10)
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                    /// Dismiss Keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel").font(.body)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .frame(height: 36).padding(.top, 4).padding(.bottom, 4)
    }
}

