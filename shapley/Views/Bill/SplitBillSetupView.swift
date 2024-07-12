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
        self._viewModel = StateObject(wrappedValue: SplitBillSetupModel(id: activityId))
        self._presented = presented
    }
    
    var body: some View {
        
            VStack(alignment: .leading) {
                
                HStack {
                    TextField("Title Name", text: $titleName)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                        .fixedSize(horizontal: true, vertical: false)
                        .multilineTextAlignment(.leading)
                        .onReceive(Just(titleName), perform: { _ in
                            titleName = TextUtil.limitText(titleName, 15)
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
                .padding(.horizontal, 35)
                
                
                
                List {
                    Section(header: Text("Receipt")
                        .font(.title2)
                        .bold()) {
                            ForEach(viewModel.sales) { item in
                                SaleView(entry: item, givenModel: viewModel)
                            }
                        }
                }
                
                SaleSummaryView(model: viewModel)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                
                Spacer()
                
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
            .alert(isPresented: $error, content: {
                Alert(title: Text("Error"), message: Text("Fill in all entries."))
            })
        }
}

#Preview {
    SplitBillSetupView(activityId: "", presented: Binding(get: {true}, set: {_ in }))
}
