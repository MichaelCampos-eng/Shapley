//
//  BillHeaderView.swift
//  shapley
//
//  Created by Michael Campos on 9/17/24.
//

import SwiftUI

struct BillHeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "newspaper.circle")
            Text("Shapley")
            Spacer()
        }
        .font(.caption)
        .foregroundStyle(Color(.secondaryLabel))
        .frame(height: 10)
        Spacer()
        HStack {
            VStack(alignment: .leading) {
                Text("Split Bill")
                    .font(Font(CTFont(.system, size: 50)))
                    .bold()
                    .shadow(radius: 10)
                Text("Swipe to select")
                    .font(.headline)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            Spacer()
        }
        .frame(height: 200)
        .padding()
    }
}

#Preview {
    BillHeaderView()
}
