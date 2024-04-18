//
//  Item.swift
//  FriendsFavoriteMovies
//
//  Created by Liam DeBeasi on 4/15/24.
//

import Foundation
import SwiftData

@Model
final class Movie: Codable {
    
    enum CodingKeys: CodingKey {
        case title
        case releaseDate
        case id
    }
    
    var title: String
    var releaseDate: Int
    var id: Int
    
    init(title: String, releaseDate: Int) {
        self.title = title
        self.releaseDate = releaseDate
        self.id = Int(Date().timeIntervalSince1970)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        releaseDate = try container.decode(Int.self, forKey: .releaseDate)
        id = try container.decode(Int.self, forKey: .id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(id, forKey: .id)
    }
}
