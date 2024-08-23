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
    @State private var isEditing: Bool = false
    @State private var editedTitle: String = ""

    init(metadata: MetaActivity) {
        self._viewModel = StateObject(
            wrappedValue: ActivityViewModel(meta: metadata))
    }
    
    var body: some View { 
        
        let photos = (1..<7).map { "photo\($0)" }
        
        if viewModel.isAvailable() {
            
            
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.almond)
                    .overlay {
                        VStack {
                            PhotoActivityView(name: photos.randomElement()!)
//                                .padding()
                            
                            
                            HStack {
                                if isEditing {
                                    TextField(editedTitle, text: $editedTitle, onCommit: {
                                        viewModel.updateTitle(name: editedTitle)
                                        isEditing = false
                                    })
                                    .foregroundStyle(Color(.secondaryLabel))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                } else {
                                    VStack(alignment: .leading) {
                                        Text(viewModel.getTitle())
                                            .foregroundStyle(Color.black)
                                            .font(.body)
                                            .bold()
                                        Text("\(Date(timeIntervalSince1970: viewModel.getCreatedDate()).formatted(date: .abbreviated, time: .shortened))")
                                            .font(.footnote)
                                            .foregroundStyle(Color.black)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    Spacer()
                                }
                                Spacer()
                                Button(action: {},
                                       label: {
                                    Image(systemName: "ellipsis")
                                        .font(.title)
                                        .foregroundStyle(Color(.black))
                                })
                            }
                            .padding(.horizontal)
                            Spacer()
                        }
                    }
                    .mask(RoundedRectangle(cornerRadius: 25.0))
                    
            }
            
            
            
            
            ////                        .swipeActions {
            ////                            if viewModel.isAdmin() && !isEditing {
            ////                                Button("Edit") {
            ////                                    isEditing = true
            ////                                }
            ////                                .tint(Color.blue)
            ////                            }
            ////                            if !isEditing {
            ////                                Button("Delete") {
            ////                                    viewModel.delete()
            ////                                }
            ////                                .tint(Color.red)
            ////                            }
            ////                        }
            //                    }
            //                    .padding()
            //                }
        }
    }
}

#Preview {
    ActivityView(metadata: MetaActivity(id: "6DE21F32-FBD8-4F26-94AC-5FA8B5EC1A5B",
                                        titleName: "",
                                        userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                                        createdDate: Date().timeIntervalSince1970))
}
