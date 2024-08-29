//
//  ItemView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import FirebaseFirestore
import SwiftUI

struct ActivityView: View {
    @StateObject var viewModel: ActivityViewModel
    @State private var editedTitle: String = ""
    @State private var isShowingOptions: Bool = false
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    
    init(metadata: MetaActivity) {
        self._viewModel = StateObject(
            wrappedValue: ActivityViewModel(meta: metadata))
    }
    
    var body: some View {
        
        let photos = (1..<7).map { "photo\($0)" }
        
        if viewModel.isAvailable() {
            ZStack {
                if isShowingOptions {
                    VStack(spacing: 0) {
                        Button(action: {
                            isShowingOptions = false
                            isEditing = true
                            isFocused = true
                        }, label: {
                            Rectangle()
                                .fill(Color.blue)
//                                .ignoresSafeArea()
                                .overlay {
                                    Text("Edit")
                                        .bold()
                                        .foregroundStyle(Color.white)
                                }
                        })
                        Button(action: {
                            isShowingOptions = false
                            viewModel.delete()
                        }, label: {
                            Rectangle()
                                .fill(Color.red)
//                                .ignoresSafeArea()
                                .overlay {
                                    Text("Delete")
                                        .bold()
                                        .foregroundStyle(Color.white)
                                }
                        })
                        Button(action: {
                            isShowingOptions = false
                        }, label: {
                            Rectangle()
                                .fill(Color.almond)
//                                .ignoresSafeArea()
                                .overlay {
                                    HStack {
                                        Image(systemName: "arrowshape.turn.up.backward")
                                        Text("Back")
                                    }
                                    .bold()
                                    .foregroundStyle(Color.walnutBrown)
                                }
                        })
                    }
                    .mask(Circle())
                    .transition(AnyTransition
                        .asymmetric(insertion: .scale,
                                    removal: .move(edge: .leading)))
                }
                    else {
                        VStack {
                            Spacer()
                            if isEditing {
                                TextField(editedTitle, text: $editedTitle, onCommit: {
                                    viewModel.updateTitle(name: editedTitle)
                                    isEditing = false
                                })
                                .foregroundStyle(Color(.secondaryLabel))
                                .padding()
                                .focused($isFocused)
                                .background {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                                        .foregroundStyle(Color.white)
                                }
                            } else {
                                HStack {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text(viewModel.getTitle())
                                            .font(.body)
                                            .bold()
                                            .foregroundStyle(Color.white)
                                        Text("\(Date(timeIntervalSince1970: viewModel.getCreatedDate()).formatted(date: .abbreviated, time: .shortened))")
                                            .font(.caption2)
                                            .foregroundStyle(Color.white)
                                    }
                                    Spacer()
                                    Button(action: {
                                        isShowingOptions.toggle()
                                    }, label: {
                                        Image(systemName: isShowingOptions ?  "arrow.turn.right.down" : "ellipsis")
                                            .rotationEffect(.degrees(isShowingOptions ? 0 : 360))
                                            .foregroundStyle(Color.white)
                                    })
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .background {
                            Circle()
                                .overlay {
                                    PhotoActivityView(name: photos.randomElement()!)
                                        .mask(Circle())
                                }
                                .shadow(radius: 10)
                        }
                    }
            }
        }
    }
}

#Preview {
    ActivityView(metadata: MetaActivity(id: "6DE21F32-FBD8-4F26-94AC-5FA8B5EC1A5B",
                                        titleName: "",
                                        userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                                        createdDate: Date().timeIntervalSince1970))
}
