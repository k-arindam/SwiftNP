import Testing
@testable import SwiftNP

@Suite("NDArray Foundation Tests")
struct NDArrayFoundationTests {
    @Test("Compare ones() with generate()")
    func compareOnesWithGenerate() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        
        let output1 = SNP.ones(shape: [1, 3, 50, 3, 1, 7])
        let output2 = try? NDArray.generate(of: [1, 3, 50, 3, 1, 7], with: 1.0)
        
        #expect(output1.toString() == output2?.toString(), "Both outputs should be equal")
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
}
