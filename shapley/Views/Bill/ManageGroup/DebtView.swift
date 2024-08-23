//
//  DebtView.swift
//  shapley
//
//  Created by Michael Campos on 8/1/24.
//

import SwiftUI

struct DebtView: View {
    
    @State private var progress: Double
    private var missing: Double
    private var total: Double
    
    init(missing: Double, total: Double) {
        self.missing = missing
        self.total = total
        self.progress = (total - missing) / total
    }
    
    var body: some View {
        GeometryReader { metrics in
            
                VStack(alignment: .leading) {
                    Text("Missing")
                        .font(.title3)
                        .foregroundStyle(Color(.secondaryLabel))
                    
                    HStack(alignment: .center) {
                        Text("$\(String(format: "%.2f", missing))")
                            .bold()
                            .font(.largeTitle)
                            .foregroundStyle(Color.white)
                        Text("/ $\(String(format: "%.2f", total))")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    // Progress bar
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .frame(height: 10)
                            .foregroundStyle(Color.gray.opacity(0.5))
                            .shadow(radius: 10)
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .frame(width: metrics.size.width * progress, height: 10)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.orange, .maize]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                            .animation(.easeInOut(duration: 0.5), value: progress)
                    }
                }
        }
    }
}

#Preview {
    DebtView(missing: 12.3, total: 23.53)
}
