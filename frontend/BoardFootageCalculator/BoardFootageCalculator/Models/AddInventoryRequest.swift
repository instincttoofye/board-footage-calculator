//
//  AddInventoryRequest.swift
//  BoardFootageCalculator
//
//  Created by Zach Baron on 10/3/26.
//
import Foundation

struct AddInventoryRequest: Encodable {
    let species: String
    let board_feet: Double
}
