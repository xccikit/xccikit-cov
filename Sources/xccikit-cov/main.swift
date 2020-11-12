import ArgumentParser

struct XCCIKitCov: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift CLI tool to convert XCodes code coverage xcresult report to other formats"
    )

    init() { }
}

XCCIKitCov.main()
