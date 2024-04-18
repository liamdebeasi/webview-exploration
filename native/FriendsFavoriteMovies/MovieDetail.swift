//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Liam DeBeasi on 4/15/24.
//

import SwiftUI
import SwiftData
import WebKit

struct MovieDetail: View {
    let isNew: Bool
    let url: String;
    
    @Environment(\.dismiss) private var dismiss
    @Query() private var movies: [Movie]
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
        
        print("Message", message.body)

        if let data = message.body as? [String: AnyObject],
            let type = data["type"] as? String {
                                    
            if type == "addMovie" {
                if let payload = data["data"] as? [String: AnyObject],
                   let name = payload["name"] as? String,
                   let releaseDate = payload["releaseDate"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.date(from: releaseDate)!
                    let epochTime = Int(formattedDate.timeIntervalSince1970)
                    
                    print(formattedDate, epochTime)
                    
                    let movie = Movie(title: name, releaseDate: epochTime)
                    modelContext.insert(movie)
                    
                    dismiss()

                }

            } else if type == "fetchMovie" {
                let payloadID = data["data"] as? String
                if payloadID == nil {
                    return
                }
                for movie in movies {
                    let toInt = Int(payloadID!)
                    if movie.id == toInt {
                        guard let json = try? JSONEncoder().encode(movie),
                              let jsonString = String(data: json, encoding: .utf8) else {
                            return
                        }
                        
                        let javascript = "window.dispatchEvent(new CustomEvent('receive-movie', { detail: \(jsonString) }));";
                        webViewCoordinator.webView?.evaluateJavaScript(javascript)
                        
                        break
                    }
                }
            }
        } else {
            print("BOO")
        }
        
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
