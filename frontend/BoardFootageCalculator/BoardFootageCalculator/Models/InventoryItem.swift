//
//  InventoryItem.swift
//  BoardFootageCalculator
//
//  Created by Zach Baron on 10/3/26.
//
import Foundation

struct InventoryItem: Codable, Identifiable {
    let id: UUID
    let species: String
    let boardFeet: Double

    enum CodingKeys: String, CodingKey {
        case id
        case species
        case boardFeet = "board_feet"
    }
}
