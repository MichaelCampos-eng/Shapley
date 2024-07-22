//
//  SplitBillView.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import SwiftUI

struct BillView: View {
    @StateObject var viewModel: BillModel
    
    init(meta: MetaTrip) {
        self._viewModel = StateObject(wrappedValue: BillModel(meta: meta))
    }
    
    var body: some View {
        
        if viewModel.isValid() {
            VStack {
                ScrollView{
                    LazyVStack {
                        ForEach(viewModel.getSales()) { item in
                            ItemBillView(sale: item,
                                         user: viewModel.userModel!,
                                         addAction: viewModel.addItem,
                                         removeAction: viewModel.removeItem)
                        }
                    }
                }
                
                HStack{
                    Spacer()
                    if viewModel.isOwner() {
                        VStack(alignment: .trailing) {
                            HStack{
                                Text( "Total: \(String(format:"%.2f", viewModel.getTotal() ))")
                                
                            }
                            HStack {
                                Text( "Your Amount: \(String(format: "%.2f", viewModel.getUserAmount()))" )
                                
                            }
                            HStack {
                                Text( "Missing: \(String(format: "%.2f", viewModel.getTotal() - viewModel.getUserAmount()))")
                                
                                    .foregroundStyle(.red)
                            }
                        }
                    } else {
                        Text("Subject POV")
                    }
                }
                
            }
            .navigationTitle(viewModel.getTitle())
            .toolbar {
                Button {
                    print("ok")
                } label: {
                    Image(systemName: "person.3")
                        .foregroundColor(.orange)
                }
                Button {
                    print("temp")
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.orange)
                }
            }
            
            
        }
        
    }
}

#Preview {
    BillView(meta: MetaTrip(id: "DkUXKLdl3wDRyl5iPdrs",
                            userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                            activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316",
                            dateCreated: TimeInterval()))
}
