//
//  ContentDetailWebView.swift
//  xsis-ios-developer-test
//
//  Created by Hubert Daryanto on 09/11/23.
//

import SwiftUI
import WebKit

struct ContentDetailWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let wkWebView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        return wkWebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
