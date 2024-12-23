import Testing

#if canImport(CoreML)
import CoreML
#endif

#if canImport(UIKit)
import UIKit
#endif

@testable import SwiftNP

@Suite("NDArray Foundation Tests")
struct NDArrayFoundationTests {
    @Test("Compare ones() with generate()")
    func compareOnesWithGenerate() async throws {
        let output1 = try! SNP.ones(shape: [1, 3, 50, 3, 1, 7])
        let output2 = try! NDArrayImpl.generate(of: [1, 3, 50, 3, 1, 7], with: 1.0)
        
        #expect(output1.toString() == output2.toString(), "Both outputs should be equal")
    }
    
    @Test("Verify conformsToShape()")
    func verifyConformsToShape() async throws {
        let input: [Any] = [
            [
                [[1], [2], [3]],
                [[4], [5], [6]],
                [[7], [8], [9]]
            ],
            [
                [[10], [11], [12]],
                [[13], [14], [15]],
                [[16], [17], [18]]
            ],
            [
                [[19], [20], [21]],
                [[22], [23], [24]],
                [[25], [26], [27]]
            ],
            [
                [[30], [31], [32]],
                [[33], [34], [35]],
                [[36], [37], [38]]
            ],
            [
                [[39], [40], [41]],
                [[42], [43], [44]],
                [[45], [46], [47]]
            ]
        ]
        
        let shape = Utils.inferShape(from: input)
        let conforms = Utils.conformsToShape(array: input, shape: shape)
        
        #expect(conforms, "Array should conform to shape")
    }
    
    @Test("Create NDArray from Swift array")
    func createNDArrayFromSwiftArray() async throws {
        let input = [
            [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 9]
            ],
            [
                [10, 11, 12],
                [13, 14, 15],
                [16, 17, 18]
            ],
            [
                [19, 20, 21],
                [22, 23, 24],
                [25, 26, 27]
            ],
            [
                [30, 31, 32],
                [33, 34, 35],
                [36, 37, 38]
            ],
            [
                [39, 40, 41],
                [42, 43, 44],
                [45, 46, 47]
            ]
        ] as [Any]
        
        let output = try? SNP.ndarray(input)
        
        #expect(output != nil)
    }
    
    @Test("Test reshape()")
    func testReshape() async throws {
        let input = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ]
        
        let output = try? SNP.ndarray(input).reshape(to: [3, 2], order: .c)
        
        debugPrint("----->>> \(String(describing: output))")
        #expect(output != nil)
    }
    
    @Test("Test equality")
    func testEquality() async throws {
//        let matrixA = [[1, 2, [3, 4]], [5, 6]]
//        let matrixB = [[1, 2, [3, 4]], [5, 6]]
//        let matrixC = [[1, 2, [3, 5]], [5, 6]]
        
        let matrixA = [[[1, 2], [3, 4]]]
        let matrixB = [[[1, 2], [3, 4]]]
        let matrixC = [[[1, 2], [3, 5]]]
        
        let array1 = try SNP.ndarray(matrixA)
        let array2 = try SNP.ndarray(matrixB)
        let array3 = try SNP.ndarray(matrixC)
        
        debugPrint("----->>> \(array1 === array3)")
        #expect(array1 === array2, "\(array1) != \(array2)")
    }
    
    @Test("Multiply By Scalar")
    func multiplyByScalar() async throws {
        let input = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ]
        
        let output = [
            [3.0, 6.0, 9.0],
            [12.0, 15.0, 18.0]
        ]
        
        let array = try SNP.ndarray(input)
        let directResult = try SNP.ndarray(output)
        let result = try array * 3.0
        
        debugPrint(result.toString() + directResult.toString())
        
        #expect(result === directResult)
    }
    
    @Test("Element-wise Addition")
    func elementWiseAddition() async throws {
        
        let input1 = [
            [[1.0], [2.0], [3.0]],
            [[4.0], [5.0], [6.0]]
        ]
        
        let input2 = [
            [[1.0], [2.0], [3.0]],
            [[4.0], [5.0], [6.0]]
        ]
        
        let output = [
            [[2.0], [4.0], [6.0]],
            [[8.0], [10.0], [12.0]]
        ]
        
        let array1 = try SNP.ndarray(input1)
        let array2 = try SNP.ndarray(input2)
        
        let array3 = try SNP.ones(shape: [9, 6, 8, 2])
        let array4 = try SNP.ones(shape: [9, 6, 8, 2])
        
        let array5 = try SNP.ndarray(output)
        let array6 = try array1 + array2
        
        let array7 = try NDArrayImpl(shape: [9, 6, 8, 2], dtype: .float64, defaultValue: 2.0)
        let array8 = try array3 + array4
        
        #expect(array5 === array6)
        #expect(array7 === array8)
    }
    
    #if canImport(UIKit)
    @available(iOS 15.0, *)
    @Test func uiimageNDArray() async throws {
        let input = UIImage(named: "banner.png", in: Bundle.module, with: nil)
        let array = try input?.toNDArray as? NDArrayImpl
        
        #expect(array != nil)
        
        if let array = array {
            let raw = try array.rawData()
            let newArray = try NDArrayImpl(array: raw, contentType: .image)
            let op = try UIImage(ndarray: newArray)
            
            debugPrint("----->>> \(array.shape), \(op.size)")
        }
    }
    #endif
    
    #if canImport(CoreML)
    @Test func mlmultiarrayNDArray() async throws {
        let input = try MLMultiArray([1, 2, 3])
        let array = try input.toNDArray
        let output = try MLMultiArray.from(ndarray: array)
        
        #expect(input == output)
        
    }
    #endif
    
    @Test func verifyTranspose() async throws {
        let array = try SNP.ndarray([[[1.0, 2.0, 9.0], [3.0, 4.0, 10.0]],
                                 [[5.0, 6.0, 11.0], [7.0, 8.0, 12.0]]])
        
        let t = try array.transpose()
        
        let output = try SNP.ndarray([[[ 1.0,  5.0],
                                       [ 3.0,  7.0]],

                                      [[ 2.0,  6.0],
                                       [ 4.0,  8.0]],

                                      [[ 9.0, 11.0],
                                       [10.0, 12.0]]])
        
        debugPrint("----->>> \(t)")
        #expect(t === output)
    }
    
    @Test func testScalarOps() async throws {
        let array = try SNP.ones(shape: [3, 2, 2, 5])
        
        let mul = try array * 3
        debugPrint("----->>> Mul: \(mul)")
        
        let div = try mul / 3
        debugPrint("----->>> Div: \(div)")
        
        #expect(array === div)
    }
    
    @Test func multiOperation() async throws {
        let input = try SNP.ndarray([[6.0, 3.0], [0.0, -3.0]])
        let output = try SNP.ndarray([[2.0, 0.0], [1.0, -1.0]])
        
        let result = try (try input / 3).transpose()
        
        #expect(result === output)
    }
    
    @Test func testDotProduct() async throws {
        let matA = try SNP.ndarray([[1.0, 2.0], [3.0, 4.0]])
        let matB = try SNP.ndarray([[1.0, 2.0], [3.0, 4.0]])
        
        let output = try SNP.ndarray([[7.0, 10.0], [15.0, 22.0]])
        let result = try SNP.dot(matA, matB)
        
        #expect(result === output)
        
        debugPrint("----->>> \(try SNP.dot(matA, matB))")
    }
}
