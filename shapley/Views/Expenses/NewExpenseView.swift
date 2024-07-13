//
//  NewTripView.swift
//  shapley
//
//  Created by Michael Campos on 6/14/24.
//

import SwiftUI

struct NewExpenseView: View {
    
    @Binding var newTripPresented: Bool
    
    @State private var receipt = true
    @State private var gas = false
    @State private var vendue = false
   
    @Namespace private var animationNamespace
    
    private var activityId: String
    
    init(activityId: String, newTripPresented: Binding<Bool>) {
        self._newTripPresented = newTripPresented
        self.activityId = activityId
    }
    
    var body: some View {
            
        VStack {
            SelectSliderView(receipt: $receipt, gas: $gas, vendue: $vendue)
                .padding(.vertical, 20)
            Divider()
            Spacer()
            
            ZStack {
                if receipt {
                    SplitBillSetupView(activityId: self.activityId, presented: $newTripPresented)
                        .matchedGeometryEffect(id: "content", in: animationNamespace)
                        .padding(.top, 10)
                } else if gas {
                    SplitGasSetupView()
                        .matchedGeometryEffect(id: "content", in: animationNamespace)
                        .padding(.top, 10)
                } else if vendue {
                    VendueSetupView()
                        .matchedGeometryEffect(id: "content", in: animationNamespace)
                        .padding(.top, 10)
                }
            }
            .animation(.bouncy, value: receipt)
            .animation(.bouncy, value: gas)
            .animation(.bouncy, value: vendue)
        }
        Spacer()
    }
        
    
}


#Preview {
    NewExpenseView(activityId: "caca", newTripPresented: Binding(get: {
        return true
    }, set: { _ in
        return
    }))
}
