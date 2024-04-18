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
    let coordinator: WebViewCoordinator?
    
    init(url: URL, coordinator: WebViewCoordinator? = nil, messageHandler: WebKitMessageHandler? = nil) {
        self.coordinator = coordinator ?? nil
        self.url = url
        self.messageHandler = messageHandler ?? nil
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView: WKWebView;
        if (self.messageHandler != nil) {
            let config = WKWebViewConfiguration()
            config.userContentController.add(self.messageHandler, name: "navigationMessageHandler")
            
            webView = WKWebView(frame: .zero, configuration: config)
        } else {
            webView = WKWebView()
        }
                
        coordinator?.webView = webView
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        webView.isInspectable = true
        
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if (url != webView.url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

class WebViewCoordinator: NSObject {
    var webView: WKWebView?
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
