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
               calculate()
           }
       }
        
    }
    
    private func calculate() {
        guard thickness > 0, length > 0, width > 0 else {
            return
        }
        
        return result = (thickness * length * width) / 144
    }
}
