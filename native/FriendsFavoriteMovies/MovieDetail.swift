//
//  MovieDetail.swift
//  FriendsFavoriteMovies
//
//  Created by Liam DeBeasi on 4/15/24.
//

import SwiftUI


struct MovieDetail: View {
    let isNew: Bool
    let movieID: String
    let url: String;
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    init(movieID: String = "", isNew: Bool = false) {
        self.isNew = isNew
        self.movieID = movieID
        self.url = "https://liam.ngrok.app" + self.movieID;
        print(self.url)
    }
    
    var body: some View {
        WebView(url: URL(string: url)!)
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isNew ? "New Movie" : "Movie")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
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
