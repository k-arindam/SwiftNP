// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class SwiftNP {
    private init() {}
    
    internal static let backend: any SNPBackend = SwiftBackend()
    internal static let backendProvider: SNPBackendProvider = .swift
    
    public static func ones<T>(shape: Shape) -> NDArray<T> where T: SNPNumeric { .init() }
    public static func zeros<T>(shape: Shape) -> NDArray<T> where T: SNPNumeric { .init() }
    
    public static func add<T>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: SNPNumeric { try lhs + rhs }
    public static func subtract<T>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: SNPNumeric { try lhs - rhs }
    
    public static func multiply<T>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: SNPNumeric { try lhs * rhs }
    public static func multiply<T>(_ lhs: NDArray<T>, _ scalar: Double) throws(SNPError) -> NDArray<T> where T: SNPNumeric { try lhs * scalar }
    
    public static func dot<T>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: SNPNumeric { try lhs.dot(rhs) }
    
    public static func divide<T>(_ lhs: NDArray<T>, _ rhs: NDArray<T>) throws(SNPError) -> NDArray<T> where T: SNPNumeric { try lhs / rhs }
    public static func divide<T>(_ lhs: NDArray<T>, _ scalar: Double) throws(SNPError) -> NDArray<T> where T: SNPNumeric { try lhs / scalar }
}
