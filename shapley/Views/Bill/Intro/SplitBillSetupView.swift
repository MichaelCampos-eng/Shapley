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
    @FocusState private var focusItem: Field?
    
    init(activityId: String, presented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: SplitBillSetupModel(id: activityId))
        self._presented = presented
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
            if focusItem == Field.title || focusItem == nil {
                HStack {
                    Text("Setup")
                        .foregroundStyle(Color.white)
                    Text("Bill")
                        .foregroundStyle(Color.roseTaupe)
                }
                .shadow(radius: 10)
                .font(.system(size: 30))
                .bold()
                HStack {
                    TextField("Tap to set title", text: $titleName)
                        .bold()
                        .fixedSize(horizontal: true, vertical: false)
                        .multilineTextAlignment(.leading)
                        .onReceive(Just(titleName), perform: { _ in
                            titleName = TextUtil.limitText(titleName, 15)
                        })
                        .foregroundStyle(Color.blue)
                        .focused($focusItem, equals: Field.title)
                    Image(systemName: "pencil")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Spacer()
                    Button {
                        viewModel.createNewEntry()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.clear)
                }
                .transition(AnyTransition
                    .asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom))
                    .combined(with: .scale))
            }
            
            if focusItem == Field.receipt || focusItem == nil {
                List {
                    Section {
                        ForEach(viewModel.sales) { item in
                            SaleView(entry: item, focused: _focusItem)
                                .listRowBackground(Color.black)
                        }
                    } header: {
                        Text("Receipt")
                            .foregroundStyle(Color.white)
                    }
                }
                .scrollContentBackground(.hidden)
                .background {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.gunMetal)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 300)
                .transition(AnyTransition
                    .asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom))
                    .combined(with: .scale))
            }
            
            if focusItem == Field.summary || focusItem == nil {
                HStack {
                    SaleSummaryView(focused: _focusItem)
                    Spacer()
                    VStack {
                        Button {
                            if viewModel.isSharable(titleName: titleName) {
                                viewModel.shareReceipt(titleName: titleName)
                                presented = false
                                self.error = false
                            } else { self.error = true }
                        } label: {
                            Text("Publish")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .foregroundColor(.white)
                                .background(Color.gunMetal)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.roseTaupe)
                        .shadow(radius: 10)
                }
                .transition(AnyTransition
                    .asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom))
                    .combined(with: .scale))
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.5), value: focusItem)
        .alert(isPresented: $error, content: {
            Alert(title: Text("Error"), message: Text("Fill in all entries."))
        })
        .environmentObject(viewModel)
    }
}

#Preview {
    SplitBillSetupView(activityId: "", presented: Binding(get: {true}, set: {_ in }))
}
