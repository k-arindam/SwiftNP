//
//  StringExtension.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

public extension String {
    
    /// Creates a localized string using a specified key and optional arguments.
    ///
    /// - Parameters:
    ///   - key: A `String.LocalizationValue` that represents the key for the localized string.
    ///   - args: An optional array of `CVarArg` to be formatted into the localized string (default is an empty array).
    /// - Returns: A formatted localized string based on the provided key and arguments.
    /// - Example:
    ///     let greeting = String.custom(key: "hello_key", args: ["World"])
    ///     // Returns a localized string for "hello_key" formatted with "World"
    static func custom(key: String.LocalizationValue, args: [CVarArg] = []) -> String {
        // Retrieve the localized string from the specified bundle
        let localized = String(localized: key, bundle: Bundle.module)
        
        // Format the localized string with the provided arguments and return it
        return String(format: localized, arguments: args)
    }
}
