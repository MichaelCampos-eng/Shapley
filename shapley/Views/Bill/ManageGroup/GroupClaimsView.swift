//
//  TESTING.swift
//  shapley
//
//  Created by Michael Campos on 8/2/24.
//

import SwiftUI

struct GroupClaimsView: View {
    private var users: BillGroup
    
    init(users: BillGroup) {
        self.users = users
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(users.validUsers, id: \.self) { user in
                        UserClaimsView(receipt: users.receipt, refPaths: user)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .scrollTransition(.interactive,
                                              axis: .horizontal) { view, phase in
                            view.offset(x: phase.value > 0 ? -20 : 0, y: phase.value > 0 ? 20 : 0)
                                .offset(y: phase.value < 0 ? 80 : 0)
                                .rotationEffect(.degrees(phase.value > 0 ? -10: 0))
                                .rotationEffect(.degrees(phase.value < 0 ?  -10 : 0))
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    GroupClaimsView(users: BillGroup(receipt: Receipt(summary: GeneralReceipt(subtotal: 12.95,
                                                                              tax: 5.55),
                                                      items: [Sale(id: "B1072282-F180-4375-BB09-BF2E3DD5386D",
                                                                   name: "Chips",
                                                                   quantity: 2,
                                                                   price: 3.98),
                                                              Sale(id: "2B50EF5E-23F8-4DFB-B914-A653BE9C5B0B",
                                                                   name: "Snapples",
                                                                   quantity: 3,
                                                                   price: 8.97)]),
                                     validUsers: [ModelPaths(id: "cG1pKA6E7gCXkysxTD3o",
                                                           userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                                                           activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316"),
                                                  ModelPaths(id: "cG1pKA6E7gCXkysxTD3o",
                                              userId: "10b8fa78neXKKsaGdiZvbnzDCN62",
                                              activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316")]))
}
