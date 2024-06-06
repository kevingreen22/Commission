//
//  AddItemToGrid.swift
//  Comish
//
//  Created by Kevin Green on 10/2/20.
//

import SwiftUI

struct AddItemToGrid: View {
    @State private var isAddingToAccounts: Bool = false
    
    var body: some View {
        Image(systemName: isAddingToAccounts ? "person.badge.plus.fill" : "plus")
            .resizable()
            .imageScale(.medium)
            .frame(width: 80, height: 80, alignment: .center)
            .foregroundColor(.white)
            .modifier(Shadow())
    }
}


struct AddItemToGrid_Previews: PreviewProvider {
    static var previews: some View {
        AddItemToGrid()
    }
}
