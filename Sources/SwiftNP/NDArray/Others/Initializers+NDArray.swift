//
//  Initializers+NDArray.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

public extension NDArray {
    convenience init() {
        self.init(shape: [], data: [])
    }
}
