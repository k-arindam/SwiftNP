import Testing
@testable import SwiftNP

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    
    let output1 = SNP.ones(shape: [1, 3, 50, 3, 1, 7])
    let output2 = NDArray.generate(of: [1, 3, 50, 3, 1, 7], with: 1.0)
    
    #expect(output1.toString() == output2.toString(), "Both outputs should be equal")
}
