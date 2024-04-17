//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Liam DeBeasi on 4/15/24.
//

import SwiftUI
import WebKit

struct MovieDetail: View {
    let isNew: Bool
    let url: String;
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    private var webViewCoordinator = WebViewCoordinator()
        
    init(path: String = "/movie", isNew: Bool = false) {
        self.isNew = isNew
        self.url = "https://liam.ngrok.app" + path;
    }
    
    var body: some View {
        WebView(url: URL(string: url)!, coordinator: webViewCoordinator, messageHandler: WebKitMessageHandler(callback: addMovieData))
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isNew ? "New Movie" : "Movie")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let javascript = "window.dispatchEvent(new CustomEvent('confirm-add-movie'));";
                        webViewCoordinator.webView?.evaluateJavaScript(javascript)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func addMovieData(message: WKScriptMessage) {
        dismiss()
    }
}


#Preview {
    NavigationStack {
        MovieDetail()
    }
    .modelContainer(SampleData.shared.modelContainer)
}


#Preview("New Movie") {
    NavigationStack {
        MovieDetail(isNew: true)
            .navigationBarTitleDisplayMode(.inline)
    }
    .modelContainer(SampleData.shared.modelContainer)
}
