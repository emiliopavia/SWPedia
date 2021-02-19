//
//  Vehicle.swift
//  SWPediaKit
//
//  Created by Emilio Pavia on 19/02/21.
//

import Foundation

public struct Vehicle: Decodable, Hashable {
    /// The name of this vehicle. The common name, such as "Sand Crawler" or "Speeder bike".
    public let name: String
    /// The model or official name of this vehicle. Such as "All-Terrain Attack Transport".
    public let model: String
    /// The class of this vehicle, such as "Wheeled" or "Repulsorcraft".
    public let vehicleClass: String
    /// The manufacturer of this vehicle. Comma separated if more than one.
    public let manufacturer: String
    /// The length of this vehicle in meters.
    public let length: String
    /// The cost of this vehicle new, in Galactic Credits
    public let costInCredits: String
    /// The number of personnel needed to run or pilot this vehicle.
    public let crew: String
    /// The number of non-essential people this vehicle can transport.
    public let passengers: String
    /// The maximum speed of this vehicle in the atmosphere.
    public let maxAtmospheringSpeed: String
    /// The maximum number of kilograms that this vehicle can transport.
    public let cargoCapacity: String
    /// The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply.
    public let consumables: String
    /// An array of Film URL Resources that this vehicle has appeared in.
    public let films: [URL]
    /// An array of People URL Resources that this vehicle has been piloted by.
    public let pilots: [URL]
    /// the hypermedia URL of this resource.
    public let url: URL
    /// the ISO 8601 date format of the time that this resource was created.
    public let created: Date
    /// the ISO 8601 date format of the time that this resource was edited.
    public let edited: Date
}
