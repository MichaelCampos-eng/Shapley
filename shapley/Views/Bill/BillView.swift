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
       Text("1) Owner, 2) Friends")
    }
}

#Preview {
    BillView(meta: MetaTrip(id: "", userId: "", activityId: "", dateCreated: TimeInterval()))
}
