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
    @FocusState private var focusItem: Bool
    
    init(activityId: String, presented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: SplitBillSetupModel(id: activityId))
        self._presented = presented
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            VStack {
                List {
                    Section("Receipt") {
                        ForEach(viewModel.sales) { item in
                            SaleView(entry: item, givenModel: viewModel, focused: _focusItem)
                                .listRowBackground(Color.walnutBrown)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.khaki)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
            }
            .padding()
            if !focusItem {
                ZStack {
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
                                .background(.orange)
                                .cornerRadius(8)
                        }
                        .zIndex(2.0)
                        .shadow(radius: 10)
                        .offset(x: 115, y: 60)
                    
                    
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sale Summary")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(Color(.secondaryLabel))
                                HStack {
                                    TextField("Receipt Name", text: $titleName)
                                        .bold()
                                        .fixedSize(horizontal: true, vertical: false)
                                        .multilineTextAlignment(.leading)
                                        .onReceive(Just(titleName), perform: { _ in
                                            titleName = TextUtil.limitText(titleName, 15)
                                        })
                                        .foregroundStyle(Color.blue)
                                    Image(systemName: "pencil")
                                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                }
                                SaleSummaryView(model: viewModel)
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .fill(Color.prussianBlue)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .stroke(Color.roseTaupe, lineWidth: 2.0)
                                    }
                            }
                            Button {
                                viewModel.createNewEntry()
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                            .padding()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 25.0)
                                .fill(Color.roseTaupe)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        }
                        .padding()
                    }
                    .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    .transition(AnyTransition
                        .asymmetric(insertion: .move(edge: .bottom),
                                    removal: .move(edge: .top))
                            .combined(with: .opacity)
                            .combined(with: .scale))
                }
            }
                Spacer()
            }
        .animation(.easeInOut(duration: 0.3), value: focusItem)
            .onTapGesture {
                focusItem = false
            }
            .alert(isPresented: $error, content: {
                Alert(title: Text("Error"), message: Text("Fill in all entries."))
            })
        }
        
}

#Preview {
    SplitBillSetupView(activityId: "", presented: Binding(get: {true}, set: {_ in }))
}
