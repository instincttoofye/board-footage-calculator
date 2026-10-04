//
//  Calculator.swift
//  BoardFootageCalculator
//
//  Created by Zach Baron on 10/3/26.
//

import SwiftUI

struct Calculator: View {
    @State var result: Double = 0
    @State var thickness: Double = 0
    @State var length: Double = 0
    @State var width: Double = 0
    @State var species: String = ""
    @State var showInventory: Bool = false
    
   var body: some View {
       VStack {
           Text("Thickness")
           TextField("Enter thickness (inches)", value: $thickness, format: .number)
           Text("Length")
           TextField("Enter length (inches)", value: $length, format: .number)
           Text("Width")
           TextField("Enter width (inches)", value: $width, format: .number)
           Text("Enter Species")
           TextField("Enter Species", text: $species)
           Text("Total Board Footage: \(result, specifier: "%.2f")")
           Button("Calculate") {
               Task {
                   await calculate()
               }
           }
           Button("Show Inventory") {
               Task {
                   await inventory()
               }
           }
       }
        
    }
    
    private func calculate() async {
        let boardFeet = (thickness * width * length) / 144

        result = boardFeet

        guard !species.isEmpty else {
            return
        }

        guard let url = URL(string: "http://localhost:3060/inventory") else {
            return
        }

        let inventory = AddInventoryRequest(
            species: species,
            board_feet: boardFeet
        )

        do {
            var request = URLRequest(url: url)

            request.httpMethod = "POST"
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )

            request.httpBody = try JSONEncoder().encode(inventory)

            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("Backend error: \(httpResponse.statusCode)")
                return
            }

            print("Added \(boardFeet) board feet of \(species)")
        } catch {
            print("Failed to add inventory: \(error)")
        }
    }
    
    private func inventory() async {
        showInventory = !showInventory
    }
}
