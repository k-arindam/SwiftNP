// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class SwiftNP {
    private init() {}
    
    internal static let backend: any SNPBackend = SwiftBackend()
    internal static let backendProvider: SNPBackendProvider = .swift
    
    public static func zeros() -> Void {}
    
    public static func ones() -> Void {}
}
