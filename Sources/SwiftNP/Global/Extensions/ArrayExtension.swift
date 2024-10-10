//
//  ArrayExtension.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 10/10/24.
//

import Foundation

public extension Array {
    var isHomogeneous: Bool {
        guard let firstElement = self.first else {
            return true
        }
        
        let expectedType = type(of: firstElement)
        
        return self.allSatisfy { element in type(of: element) == expectedType }
    }
}
