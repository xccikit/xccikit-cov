//
//  XCResultCov.swift
//  ArgumentParser
//
//  Created by Tristian Azuara on 11/12/20.
//

class XCResultCovCommon: Decodable {
    let coveredLines: UInt
    let lineCoverage: Double
    let executableLines: UInt

    init(coveredLines: UInt, lineCoverage: Double, executableLines: UInt) {
        self.coveredLines = coveredLines
        self.lineCoverage = lineCoverage
        self.executableLines = executableLines
    }
}

class XCResultCov: XCResultCovCommon {
    let targets: [XCResultCovTarget]
    
    enum CodingKeys: String, CodingKey {
        case targets
    }
    
    init(coveredLines: UInt, lineCoverage: Double, executableLines: UInt, targets: [XCResultCovTarget]) {
        self.targets = targets
        super.init(coveredLines: coveredLines, lineCoverage: lineCoverage, executableLines: executableLines)
    }
    
    required init(from decoder: Decoder) throws {
        targets = try (try decoder.container(keyedBy: CodingKeys.self))
            .decode([XCResultCovTarget].self, forKey: .targets)
        try super.init(from: decoder)
    }
}
