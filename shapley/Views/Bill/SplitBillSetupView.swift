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
    @Binding var presented: Bool
    @State var titleName: String = ""
    @State private var error: Bool = false
    
    init(activityId: String, presented: Binding<Bool>) {
        print("Starting SPLIT BILL VIEW")
        self._viewModel = StateObject(wrappedValue: SplitBillSetupModel(id: activityId))
        self._presented = presented
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
            
    
            
            SaleSummaryView(model: viewModel)
            
            Spacer()
            
            if error {
                HStack {
                    Spacer()
                    Text("Fill in all entries appropriately before publishing.")
                        .foregroundStyle(.red)
                        .padding()
                    Spacer()
                }
            }
            
            HStack(alignment: .center) {
                Spacer()
                Button {
                    if viewModel.isSharable(titleName: titleName) {
                        viewModel.shareReceipt(titleName: titleName)
                        presented = false
                        self.error = false
                    } else {
                        self.error = true
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
    SplitBillSetupView(activityId: "caca", presented: Binding(get: {true}, set: {_ in }))
}
