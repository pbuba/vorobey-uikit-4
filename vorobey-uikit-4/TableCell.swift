//
//  TableCell.swift
//  vorobey-uikit-4
//
//  Created by Павел Бубликов on 12.03.2023.
//

import UIKit

class TableCell: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func == (lhs: TableCell, rhs: TableCell) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    let title: String
    var isChecked: Bool
    
    init(title: String, isChecked: Bool = false) {
        self.title = title
        self.isChecked = isChecked
    }
}
