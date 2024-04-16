//
//  ContentView.swift
//  FriendsFavoriteMovies
//
//  Created by Liam DeBeasi on 4/15/24.
//

import SwiftUI
import SwiftData
import WebKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Movie.title) private var movies: [Movie]
    @State var pushActive = false
    
    @State private var newMovie: Movie?


    var body: some View {
        NavigationSplitView {
            WebView(url: URL(string: "https://liam.ngrok.app/")!, messageHandler: WebKitMessageHandler(callback: self.pushView))
                .ignoresSafeArea()
                .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Movies")
            .toolbar {
                ToolbarItem {
                    Button(action: addMovie) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            NavigationLink(destination: MovieDetail(), isActive: $pushActive) {
                EmptyView()
            }.hidden()
            
        } detail: {
            Text("Select a movie")
                .navigationTitle("Movie")
        }
    }
    
    private func pushView(message: WKScriptMessage) {
        self.pushActive = true;
    }


    private func addMovie() {
        withAnimation {
            let newItem = Movie(title: "", releaseDate: .now)
            newMovie = newItem
        }
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
