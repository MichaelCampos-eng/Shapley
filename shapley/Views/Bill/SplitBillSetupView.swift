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
        self._viewModel = StateObject(wrappedValue: SplitBillSetupModel(activityId: activityId))
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
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
            
            List(viewModel.items) { item in
                
                let delete = ({value in self.viewModel.delete(id: value)})
                let update = ({id, value in self.viewModel.update(id: id, sale: value)})
                let fetch = ({id in return self.viewModel.get(id: id)})
                
                SaleView(saleId: item.id,
                         delete: delete,
                         update: update,
                         fetch: fetch)
            }
            .listStyle(PlainListStyle())
            
            SaleSummaryView(amount: $viewModel.subtotal)
            
            Spacer()
            
            HStack(alignment: .center) {
                Spacer()
                Button {
                    
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
