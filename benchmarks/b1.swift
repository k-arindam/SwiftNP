import Foundation

func b1() {
    let img = load_image(path: "assets/banner.png")

    let randomImage1 = generateRandomImageArray(width: 1920, height: 1080)
    let randomImage2 = Array(
        repeating: Array(repeating: Array(repeating: 70, count: 3), count: 1920), count: 1080)

    let startTime = CFAbsoluteTimeGetCurrent()

    arithmeticOperation(randomImage1, randomImage2)

    let endTime = CFAbsoluteTimeGetCurrent()
    let elapsedTime = endTime - startTime

    bprint("Image processing completed in \(elapsedTime) seconds.")
}

func arithmeticOperation(_ me: [Any], _ other: [Any]) -> [any Numeric] {
    // Flatten the data from both NDArray instances for element-wise operations.
    var flatArrayLHS = flattenedData(me)
    let flatArrayRHS = flattenedData(other)

    // Iterate over the flattened arrays to perform the specified operation.
    for (index, element) in flatArrayLHS.enumerated() {
        let lhs = element
        let rhs = flatArrayRHS[index]

        // Initialize a variable to hold the result of the operation.
        flatArrayLHS[index] = Float32(
            exactly: NSNumber(value: lhs.nsnumber.doubleValue + rhs.nsnumber.doubleValue))!
    }

    return flatArrayLHS
}
