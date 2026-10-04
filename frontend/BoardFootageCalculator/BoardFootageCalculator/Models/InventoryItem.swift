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
    let board_feet: Double
}
