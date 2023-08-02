//
//  NSCollectionExtension.swift
//  Mesence
//
//  Created by 罗志华 on 2023/8/2.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
