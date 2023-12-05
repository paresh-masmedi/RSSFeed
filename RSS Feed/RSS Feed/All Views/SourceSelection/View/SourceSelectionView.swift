//
//  SourceSelectionView.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 05/12/23.
//

import SwiftUI

struct SourceSelectionView: View {
    //Selected Items
    @Binding var selectedItems: Array<Endpoint>
    
    //All items
    let items = Endpoint.allCases

    var body: some View {
        //Source List
        List {
            //Iterate
            ForEach(self.items, id: \.self) { item in
                MultipleSelectionRow(title: item.rawValue.replacingOccurrences(of: "-", with: " ").capitalized, isSelected: self.selectedItems.contains(item)) {
                    if self.selectedItems.contains(item) {
                        //Minimum one is selected
                        if self.selectedItems.count > 1 {
                            self.selectedItems.removeAll(where: { $0 == item })
                        }
                    }
                    else {
                        self.selectedItems.append(item)
                    }
                }
            }
        }
        .navigationTitle("Source Selection")
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                    .foregroundColor(isSelected ? .blue : .black)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

