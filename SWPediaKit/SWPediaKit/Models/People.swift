//
//  People.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 17/02/21.
//

import Foundation

public struct People: Decodable, Hashable {
    /// The name of this person.
    public let name: String
    /// The birth year of the person, using the in-universe standard of BBY or ABY
    public let birthYear: String
    /// The eye color of this person. Will be "unknown" if not known or "n/a" if the person does not have an eye.
    public let eyeColor: String
    /// The gender of this person. Either "Male", "Female" or "unknown", "n/a" if the person does not have a gender.
    public let gender: String
    /// The hair color of this person. Will be "unknown" if not known or "n/a" if the person does not have hair.
    public let hairColor: String
    /// The height of the person in centimeters.
    public let height: String
    /// The mass of the person in kilograms.
    public let mass: String
    /// The skin color of this person.
    public let skinColor: String
    /// The URL of a planet resource, a planet that this person was born on or inhabits.
    public let homeworld: URL
    /// An array of film resource URLs that this person has been in.
    public let films: [URL]
    /// An array of species resource URLs that this person belongs to.
    public let species: [URL]
    /// An array of starship resource URLs that this person has piloted.
    public let starships: [URL]
    /// An array of vehicle resource URLs that this person has piloted.
    public let vehicles: [URL]
    /// the hypermedia URL of this resource.
    public let url: URL
    /// the ISO 8601 date format of the time that this resource was created.
    public let created: Date
    /// the ISO 8601 date format of the time that this resource was edited.
    public let edited: Date
}
