//
//  NewTripView.swift
//  shapley
//
//  Created by Michael Campos on 6/14/24.
//

import SwiftUI

struct NewTripView: View {
    
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
                .padding(.top, 20)
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
            .animation(.smooth, value: receipt)
            .animation(.smooth, value: gas)
            .animation(.smooth, value: vendue)
        }
        Spacer()
    }
        
    
}


#Preview {
    NewTripView(activityId: "caca", newTripPresented: Binding(get: {
        return true
    }, set: { _ in
        return
    }))
}
