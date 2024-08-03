//
//  PieChartBill.swift
//  shapley
//
//  Created by Michael Campos on 7/31/24.
//

import SwiftUI
import Charts

struct MacroData {
    let name: String
    let value: Int
}

struct PieChartBillView: View {
    
    @State private var macros: [MacroData] = [
        .init(name: "Protein", value: 180),
        .init(name: "Carbs", value: 250),
        .init(name: "fat", value: 55)
    ]
    
    var body: some View {
        ZStack {
            Chart(macros, id: \.name) { macro in
                SectorMark(angle: .value("Macros", macro.value),
                           innerRadius: .ratio(0.618),
                           angularInset: 1.5)
                .cornerRadius(4)
                .foregroundStyle(by: .value("Name", macro.name))
            }
            .chartLegend(position: .trailing, alignment: .top)
            .chartXAxis(.hidden)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    if let anchor = chartProxy.plotFrame {
                        let frame = geometry[anchor]
                        Text("Share of Cost")
                            .position(x: frame.midX, y: frame.midY)
                            .bold()
                    }
                }
            }
            .padding()
        }
  
    }
}

#Preview {
    PieChartBillView()
}
