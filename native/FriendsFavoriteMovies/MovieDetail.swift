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
    let url: String
    var addCallback: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @Query() private var movies: [Movie]
    @Environment(\.modelContext) private var modelContext
    
    private var webViewCoordinator = WebViewCoordinator()
        
    init(path: String = "/movie", isNew: Bool = false, addCallback: (() -> Void)? = nil) {
        self.isNew = isNew
        self.url = "http://localhost:9000" + path;
        self.addCallback = addCallback ?? nil
    }
    
    var body: some View {
        WebView(url: URL(string: url)!, coordinator: webViewCoordinator, messageHandler: WebKitMessageHandler(callback: addMovieData))
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isNew ? "New Movie" : "Message")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let javascript = "window.dispatchEvent(new CustomEvent('add-movie-confirm-response'));";
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
    
    func addMovieData(message: WKScriptMessage) -> Any {
        
        print("Message", message.body)

        if let data = message.body as? [String: AnyObject],
            let type = data["type"] as? String {
                                    
            if type == "add-movie" {
                if let payload = data["data"] as? [String: AnyObject],
                   let title = payload["title"] as? String,
                   let releaseDate = payload["releaseDate"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.date(from: releaseDate)!
                    let epochTime = Int(formattedDate.timeIntervalSince1970 * 1000)
                    
                    print(formattedDate, epochTime)
                    
                    let movie = Movie(title: title, releaseDate: epochTime)
                    modelContext.insert(movie)
                    
                    if (self.addCallback != nil) {
                        self.addCallback!()
                    }
                    dismiss()

                }

            } else if type == "fetch-movie" {
                let payloadID = data["data"] as? String
                if payloadID == nil {
                    return false
                }
                for movie in movies {
                    let toInt = Int(payloadID!)
                    if movie.id == toInt {
                        guard let json = try? JSONEncoder().encode(movie),
                              let jsonString = String(data: json, encoding: .utf8) else {
                            return false
                        }
                        
                        return jsonString
                    }
                }
            }
        }
        return true
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
