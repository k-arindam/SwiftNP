import Testing
import Foundation
@testable import SwiftNP

@Suite("SwiftNP Benchmarks")
struct SwiftNPBenchmarks {
    @Test func performanceExample1() async throws {
        let width = 1920
        let height = 1080
        
        let array1 = generateRandomArray(width: width, height: height)
        let array2 = generateRandomArray(width: width, height: height)
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let _ = add(array1, array2)
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let elapsedTime = endTime - startTime
        
        print("----->>> Image processing completed in \(elapsedTime) seconds.")
    }
    
    private func generateRandomArray(width: Int, height: Int) -> [Any] {
        var array: [[[Int]]] = Array(
            repeating: Array(repeating: Array(repeating: 0, count: 3), count: width), count: height)
        
        for y in 0..<height {
            for x in 0..<width {
                for channel in 0..<3 {  // RGB channels
                    array[y][x][channel] = Int.random(in: 0...255)
                }
            }
        }
        
        return array
    }
    
    private func flattenedData(_ data: [Any]) -> [any Numeric] {
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
    
    private func add(_ lhs: [Any], _ rhs: [Any]) -> [any Numeric] {
        let lhsFlatStart = CFAbsoluteTimeGetCurrent()
        var flatArrayLHS = flattenedData(lhs)
        let lhsFlatEnd = CFAbsoluteTimeGetCurrent()
        let lhsFlatTime = lhsFlatEnd - lhsFlatStart
        debugPrint("----->>> LHS Flat Time: \(lhsFlatTime) seconds.")
        
        let rhsFlatStart = CFAbsoluteTimeGetCurrent()
        let flatArrayRHS = flattenedData(rhs)
        let rhsFlatEnd = CFAbsoluteTimeGetCurrent()
        let rhsFlatTime = rhsFlatEnd - rhsFlatStart
        debugPrint("----->>> RHS Flat Time: \(rhsFlatTime) seconds.")
        
        for (index, element) in flatArrayLHS.enumerated() {
            let lhs = element
            let rhs = flatArrayRHS[index]
            
            // Initialize a variable to hold the result of the operation.
            flatArrayLHS[index] = Float32(
                exactly: NSNumber(value: lhs.nsnumber.doubleValue + rhs.nsnumber.doubleValue))!
        }
        
        return flatArrayLHS
    }
}
