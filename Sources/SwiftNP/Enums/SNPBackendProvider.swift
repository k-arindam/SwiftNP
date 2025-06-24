//
//  SNPBackendProvider.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 08/04/25.
//

import Foundation

public enum SNPBackendProvider: Sendable, Codable, CaseIterable {
    case accelerate
    case swift
}
