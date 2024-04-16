//
//  WebView.swift
//  FriendsFavoriteMovies
//
//  Created by Liam DeBeasi on 4/15/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let messageHandler: WebKitMessageHandler!;
    
    init(url: URL, messageHandler: WebKitMessageHandler? = nil) {
        self.url = url
        self.messageHandler = messageHandler ?? nil
    }
    
    func makeUIView(context: Context) -> WKWebView {
        if (self.messageHandler != nil) {
            let config = WKWebViewConfiguration()
            config.userContentController.add(messageHandler, name: "navigationMessageHandler")
            return WKWebView(frame: .zero, configuration: config)
        }
        
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
        webView.isInspectable = true
    }
}

class WebKitMessageHandler: NSObject, WKScriptMessageHandler {
    private var callback: (_: WKScriptMessage) -> Void
    
    init(callback: @escaping (_: WKScriptMessage) -> Void) {
        self.callback = callback;
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.callback(message)
    }
}

#Preview {
    WebView(url: URL(string: "http://apple.com")!)
}