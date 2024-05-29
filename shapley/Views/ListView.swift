//
//  ListView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct ListView: View {
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                NavigationLink(destination: SplitGasView(userId: self.userId)) {
                    SelectView(title: "Split Gas",
                               background: Color.teal,
                               angle: 10,
                               width: 10000)
                }
                
            
                NavigationLink(destination: SplitBillView(userId: self.userId), label: {SelectView(title: "Split Bill", background: Color.indigo, angle: 10, width: 10000)})
                
           
                
                NavigationLink(destination: VendueView(userId: self.userId)) {
                    SelectView(title: "Vendue",
                               background: Color.purple,
                               angle: 10,
                               width: 10000)
                }
                
            }
            .navigationTitle("Get Started")
            .padding(30)
        }
    }
}

#Preview {
    ListView(userId: "Example")
}
