//
//  DebtView.swift
//  shapley
//
//  Created by Michael Campos on 8/1/24.
//

import SwiftUI

struct DebtView: View {
    @EnvironmentObject var viewModel: ManageBillGroupModel
    
    var body: some View {
        GeometryReader { metrics in
            VStack(alignment: .leading) {
                Text("Missing")
                    .font(.title3)
                    .foregroundStyle(Color(.secondaryLabel))
                HStack(alignment: .center) {
                    Text("$\(String(format: "%.2f", viewModel.receipt!.missingAmount))")
                        .bold()
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                    Text("/ $\(String(format: "%.2f", viewModel.receipt!.summary.total))")
                        .foregroundStyle(Color(.secondaryLabel))
                }
                // Progress bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .frame(height: 10)
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .shadow(radius: 10)
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .frame(width: metrics.size.width * viewModel.receipt!.progress,
                               height: 10)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.orange, .maize]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                        .animation(.spring(Spring(duration: 0.3, bounce: 0.3), blendDuration: 0.1), 
                                   value: viewModel.receipt!.progress)
                }
            }
        }
    }
}

//#Preview {
//    DebtView(items: Binding(get: {[]}, set: {_ in }))
//}
