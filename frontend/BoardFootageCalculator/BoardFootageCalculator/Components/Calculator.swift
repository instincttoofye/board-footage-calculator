//
//  Calculator.swift
//  BoardFootageCalculator
//
//  Created by Zach Baron on 10/3/26.
//

import SwiftUI


struct Calculator: View {
    @State private var result: Double = 0
    @State private var thickness: Double = 0
    @State private var length: Double = 0
    @State private var width: Double = 0
    @State private var species: String = ""
    @State private var inventoryItems: [InventoryItem] = []
    @State private var showInventory: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: 0x084719),
                    Color(hex: 0x0a0e0d)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Thickness")
                    .font(.custom("GoodTimes-Regular", size: 24))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                TextField("Enter thickness (inches)", value: $thickness, format: .number)
                    .font(.custom("GoodTimes-Regular", size: 18))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                Text("Length")
                    .font(.custom("GoodTimes-Regular", size: 24))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                TextField("Enter length (inches)", value: $length, format: .number)
                    .font(.custom("GoodTimes-Regular", size: 18))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                Text("Width")
                    .font(.custom("GoodTimes-Regular", size: 24))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                TextField("Enter width (inches)", value: $width, format: .number)
                    .font(.custom("GoodTimes-Regular", size: 18))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                Text("Enter Species")
                    .font(.custom("GoodTimes-Regular", size: 24))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                TextField("Enter Species", text: $species)
                    .font(.custom("GoodTimes-Regular", size: 18))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                Text("Total Board Footage: \(result, specifier: "%.2f")")
                    .font(.custom("GoodTimes-Regular", size: 18))
                    .foregroundStyle(Color(hex: 0x85b391))
                
                Button {
                    Task {
                        await calculate()
                    }
                } label: {
                    Text("Calculate")
                        .font(.custom("GoodTimes-Regular", size: 18))
                        .foregroundStyle(Color(hex: 0x9dc2a7))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background{
                            LinearGradient(
                                colors: [
                                    Color(hex: 0x3c854f),
                                    Color(hex: 0x021407)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                
                Button {
                    Task {
                        await updateInventory(action: "add")
                    }
                } label: {
                    Text("Add to Inventory")
                        .font(.custom("GoodTimes-Regular", size: 18))
                        .foregroundStyle(Color(hex: 0x9dc2a7))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background{
                            LinearGradient(
                                colors: [
                                    Color(hex: 0x3c854f),
                                    Color(hex: 0x021407)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                Button {
                    Task {
                        await updateInventory(action: "subtract")
                    }
                } label: {
                    Text("Subtract From Inventory")
                        .font(.custom("GoodTimes-Regular", size: 18))
                        .foregroundStyle(Color(hex: 0x9dc2a7))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background{
                            LinearGradient(
                                colors: [
                                    Color(hex: 0x3c854f),
                                    Color(hex: 0x021407)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                
                Button {
                    Task {
                        await inventory()
                    }
                } label: {
                    Text("Show Inventory")
                        .font(.custom("GoodTimes-Regular", size: 18))
                        .foregroundStyle(Color(hex: 0x9dc2a7))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background{
                            LinearGradient(
                                colors: [
                                    Color(hex: 0x3c854f),
                                    Color(hex: 0x021407)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                
                if showInventory {
                    VStack {
                        Text("Inventory")
                            .font(.custom("GoodTimes-Regular", size: 24))
                            .foregroundStyle(Color(hex: 0xb6d1bd))
                        
                        ForEach(inventoryItems) { item in
                            HStack {
                                Text(item.species)
                                    .font(.custom("GoodTimes-Regular", size: 18))
                                    .foregroundStyle(Color(hex: 0xb6d1bd))
                                
                                Spacer()
                                
                                Text("\(item.boardFeet, specifier: "%.2f") Board Feet")
                                    .font(.custom("GoodTimes-Regular", size: 18))
                                    .foregroundStyle(Color(hex: 0xb6d1bd))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func calculate() async {
        let boardFeet = (thickness * width * length) / 144

        result = boardFeet
    }
    
    private func updateInventory(action: String) async {
        guard !species.isEmpty else { return }

        guard let url = URL(
            string: "http://localhost:3060/inventory/\(action)"
        ) else {
            return
        }

        let inventory = AddInventoryRequest(
            species: species,
            board_feet: result
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

            print("\(action) \(result) board feet of \(species)")
        } catch {
            print("Failed to update inventory: \(error)")
        }
    }
    
    private func inventory() async {
        guard let url = URL(string: "http://localhost:3060/inventory") else {
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("Backend error: \(httpResponse.statusCode)")
                return
            }

            let inventory = try JSONDecoder().decode(
                [InventoryItem].self,
                from: data
            )

            inventoryItems = inventory
            showInventory = !showInventory

        } catch {
            print("Failed to get inventory: \(error)")
        }
    }
}
