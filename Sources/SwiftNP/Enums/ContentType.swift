//
//  ContentType.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 14/10/24.
//

import Foundation

/// An enumeration representing different types of content.
/// `ContentType` provides a way to categorize data.
/// It conforms to `CaseIterable` for easy iteration and `Codable` to support encoding and decoding.
///
public enum ContentType: CaseIterable, Codable {
    /// - `image`: Represents image content.
    case image
    
    /// - `unknown`: Represents any other content type that does not fit into predefined categories.
    case unknown
}
