//
//  Film.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 19/02/21.
//

import Foundation

public struct Film: Decodable, Hashable {
    /// The title of this film
    public let title: String
    /// The episode number of this film.
    public let episodeId: Int
    /// The opening paragraphs at the beginning of this film.
    public let openingCrawl: String
    /// The name of the director of this film.
    public let director: String
    /// The name(s) of the producer(s) of this film. Comma separated.
    public let producer: String
    /// The ISO 8601 date format of film release at original creator country.
    public let releaseDate: String
    /// An array of people resource URLs that are in this film.
    public let characters: [URL]
    /// An array of planet resource URLs that are in this film.
    public let planets: [URL]
    /// An array of starship resource URLs that are in this film.
    public let starships: [URL]
    /// An array of vehicle resource URLs that are in this film.
    public let vehicles: [URL]
    /// An array of species resource URLs that are in this film.
    public let species: [URL]
    /// the ISO 8601 date format of the time that this resource was created.
    public let created: Date
    /// the ISO 8601 date format of the time that this resource was edited.
    public let edited: Date
    /// the hypermedia URL of this resource.
    public let url: URL
}

extension Film {
    public var releaseYear: String {
        String(releaseDate.split(separator: "-").first ?? "")
    }
}
