//
//  ContentView.swift
//  FriendsFavoriteMovies
//
//  Created by Liam DeBeasi on 4/15/24.
//

import SwiftUI
import SwiftData
import WebKit
import Foundation
import Telegraph

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Movie.title) private var movies: [Movie]
    @State var pushActive = false
    @State var pushPath = ""
    
    @State private var showNewMovieView: Bool = false;
    private var webViewCoordinator = WebViewCoordinator()
        
    var server: Server!
    
    init() {
        // Serve the Server from Build folder
        server = Server()
        let demoBundleURL = Bundle.main.url(forResource: "browser", withExtension: nil)!
        
        let baseURI = URI(path: "/")
        let handler = HTTPFileHandler(directoryURL: demoBundleURL, baseURI: baseURI, index: "index.html")
        
        server.route(.GET, "/*") { request in
            try handler.responseForURL(demoBundleURL, byteRange: nil, request: request)
        }

        try? server.start(port: 9000, interface: "localhost")
    }
    
    var body: some View {
        NavigationSplitView {
            WebView(url: URL(string: "http://localhost:9000/")!, coordinator: webViewCoordinator, messageHandler: WebKitMessageHandler(callback: self.handlerCallback))
                .ignoresSafeArea()
                .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Inbox")
            .toolbar {
                ToolbarItem {
                    Button(action: addMovie) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewMovieView) {
                NavigationView {
                    MovieDetail(path: "/movie", isNew: true, addCallback: refreshMovies)
                }
            }
            NavigationLink(destination: MovieDetail(path: self.pushPath), isActive: $pushActive) {
                EmptyView()
            }.hidden()
            
        } detail: {
            Text("Select a movie")
        }
    }

    private func addMovie() {
        let javascript = "window.dispatchEvent(new CustomEvent('add-movie-activate-response'));"
        webViewCoordinator.webView?.evaluateJavaScript(javascript)
    }
    
    private func refreshMovies() {
        guard let json = try? JSONEncoder().encode(movies),
              let jsonString = String(data: json, encoding: .utf8) else {
            return
        }
        
        
        let javascript = "window.dispatchEvent(new CustomEvent('fetch-movies-response', { detail: \(jsonString) }));"
        webViewCoordinator.webView?.evaluateJavaScript(javascript)
        
        return
    }
    
    private func handlerCallback(message: WKScriptMessage) -> Any {
        if let data = message.body as? [String: AnyObject],
            let type = data["type"] as? String {
                        
            if type == "navigate-movie-view" {
                if let payload = data["data"] as? String {
                    self.pushActive = true
                    self.pushPath = payload
                } else {
                    self.showNewMovieView = true
                }
            } else if type == "fetch-movies" {
                guard let json = try? JSONEncoder().encode(movies),
                      let jsonString = String(data: json, encoding: .utf8) else {
                    return false
                }
                
                return jsonString
            }
        }
        
        return true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(movies[index])
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}


#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Movie.self, inMemory: true)
}
