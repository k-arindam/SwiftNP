// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class SwiftNP {
    private init() {}
    
    internal static let backend: any SNPBackend = AccelerateBackend()
    internal static let backendProvider: SNPBackendProvider = .accelerate
}
