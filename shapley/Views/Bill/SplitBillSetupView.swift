//
//  SplitBillSetupView.swift
//  shapley
//
//  Created by Michael Campos on 6/24/24.
//

import SwiftUI
import Combine

struct SplitBillSetupView: View {
    
    @StateObject var viewModel: SplitBillSetupModel
    @State var titleName: String = ""
    
    init(activityId: String) {
        self._viewModel = StateObject(wrappedValue: SplitBillSetupModel(id: activityId))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                TextField("Title Name", text: $titleName)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .background(.clear)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fixedSize(horizontal: true, vertical: false)
                    .multilineTextAlignment(.leading)
                    .onReceive(Just(titleName), perform: { _ in
                        limitText(15)
                    })
                
                Image(systemName: "pencil")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Button {
                    viewModel.createNewEntry()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.orange)
                }
            }
            .padding(.trailing, 20)
            
            HStack {
                Text("Receipt")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.horizontal, 10)
            
            List(viewModel.sales) { item in
                SaleView(entry: item, givenModel: viewModel)
            }
            .listStyle(PlainListStyle())
            
            SaleSummaryView(amount: $viewModel.subtotal)
            
            Spacer()
            
            HStack(alignment: .center) {
                Spacer()
                Button {
                    if viewModel.sharable {
                        viewModel.shareReceipt(titleName: titleName)
                    }
                    
                } label: {
                    Text("Publish")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(.orange.opacity(0.7))
                        .cornerRadius(8)
                }
                Spacer()
            }
            
        }
    }

    func limitText(_ upper: Int) {
        if titleName.count > upper {
            titleName = String(titleName.prefix(upper))
        }
    }
    
}

#Preview {
    SplitBillSetupView(activityId: "caca")
}
