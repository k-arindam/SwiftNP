import AppKit
import CoreGraphics
import Foundation

public func load_image(path: String) -> NSImage? {
    let url = URL(fileURLWithPath: path)

    guard let image = NSImage(contentsOf: url) else {
        bprint("Failed to load image from path: \(path)")
        return nil
    }

    return image
}

func flattenedData(_ data: [Any]) -> [any Numeric] {
    /// A recursive function to flatten the NDArray.
    ///
    /// - Parameter array: The NDArray to be flattened.
    /// - Throws: `SNPError.typeError` if any element is not a numeric type.
    func flatten(_ array: [Any]) -> [any Numeric] {
        var flattened = [any Numeric]()  // Initialize an empty array to hold the flattened values

        // Iterate over each element in the NDArray's data
        for element in array {
            // If the element is another NDArray, recursively flatten it
            if let element = element as? [Any] {
                flattened.append(contentsOf: flatten(element))
            }
            // If the element is a numeric type, add it to the flattened array
            else if let element = element as? any Numeric {
                flattened.append(element)
            }
            // If the element is neither, throw a type error
            else {
                fatalError("UnknownDType: \(type(of: element))")
            }
        }

        return flattened  // Return the flattened array
    }

    return flatten(data)  // Call the flatten function on the current NDArray
}

func generateRandomImageArray(width: Int, height: Int) -> [[[Int]]] {
    var imageArray: [[[Int]]] = Array(
        repeating: Array(repeating: Array(repeating: 0, count: 3), count: width), count: height)

    for y in 0..<height {
        for x in 0..<width {
            for channel in 0..<3 {  // RGB channels
                imageArray[y][x][channel] = Int.random(in: 0...255)
            }
        }
    }

    return imageArray
}

public func bprint(_ msg: String) {
    print("----->>> \(msg)")
}

extension Numeric {
    /// This property uses pattern matching to determine the type of the numeric value
    /// and returns an `NSNumber` representation for different numeric types.
    ///
    /// - Supported types: `Int`, `Int8`, `Int16`, `Int32`, `Int64`, `UInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64`,
    ///   `Float`, `Float16`, `Float32`, `Float64`, `Double`.
    ///
    /// - If the numeric type is unsupported, it triggers a fatal error.
    var nsnumber: NSNumber {
        switch self {
        case let intValue as Int:
            return NSNumber(value: intValue)
        case let int8Value as Int8:
            return NSNumber(value: int8Value)
        case let int16Value as Int16:
            return NSNumber(value: int16Value)
        case let int32Value as Int32:
            return NSNumber(value: int32Value)
        case let int64Value as Int64:
            return NSNumber(value: int64Value)
        case let uintValue as UInt:
            return NSNumber(value: uintValue)
        case let uint8Value as UInt8:
            return NSNumber(value: uint8Value)
        case let uint16Value as UInt16:
            return NSNumber(value: uint16Value)
        case let uint32Value as UInt32:
            return NSNumber(value: uint32Value)
        case let uint64Value as UInt64:
            return NSNumber(value: uint64Value)
        case let floatValue as Float:
            return NSNumber(value: floatValue)
        case let floatValue as Float16:
            return NSNumber(value: Float(exactly: floatValue)!)
        case let floatValue as Float32:
            return NSNumber(value: floatValue)
        case let floatValue as Float64:
            return NSNumber(value: floatValue)
        case let doubleValue as Double:
            return NSNumber(value: doubleValue)
        default:
            fatalError("Unsupported numeric type")
        }
    }
}
