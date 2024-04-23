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
        let config = WKWebViewConfiguration()
        
        if (self.messageHandler != nil) {
            config.userContentController.addScriptMessageHandler(self.messageHandler, contentWorld: WKContentWorld.page, name: "messageHandler")
        }
        
        config.processPool = WKProcessPool()

        let webView = WKWebView(frame: .zero, configuration: config)
                
        coordinator?.webView = webView
        
        let request = URLRequest(url: url)
        webView.load(request)
        webView.isOpaque = false;
        webView.backgroundColor = .clear;
        webView.isInspectable = true
        
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if (url != webView.url) {
            /**
             * Do not call webView.load because that will cause a full page reload. Instead, all we want to do
             * is use the SPA router to mount the new component which allows us to avoid a full page reload
             * and improve performance.
             */            
            let javascript = "window.dispatchEvent(new CustomEvent('native-route', { detail: '\(url.path)' }));"
            webView.evaluateJavaScript(javascript)
            
            //webView.load(request)
        }
    }
}

class WebViewCoordinator: NSObject {
    var webView: WKWebView?
}

class WebKitMessageHandler: NSObject, WKScriptMessageHandlerWithReply {
    private var callback: (_: WKScriptMessage) -> Any
    
    init(callback: @escaping (_: WKScriptMessage) -> Any) {
        self.callback = callback;
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {
        let returnValue = self.callback(message)
        replyHandler(returnValue, nil)
    }
}

#Preview {
    WebView(url: URL(string: "http://apple.com")!)
}
