//
//  XCResultCovFunction.swift
//  ArgumentParser
//
//  Created by Tristian Azuara on 11/12/20.
//

/**
 //     {
 //       "coveredLines": 0,
 //       "lineCoverage": 0,
 //       "lineNumber": 21,
 //       "executionCount": 0,
 //       "name": "-[JCTagListView initWithFrame:]",
 //       "executableLines": 7
 //     },
 */
class XCResultCovFunction: XCResultCovCommon {
    let lineNumber: UInt
    let executionCount: UInt
    let name: String
    
    init(coveredLines: UInt, lineCoverage: Double, executableLines: UInt,
                  lineNumber: UInt, executionCount: UInt, name: String) {
        self.lineNumber = lineNumber
        self.executionCount = executionCount
        self.name = name
        super.init(coveredLines: coveredLines, lineCoverage: lineCoverage, executableLines: executableLines)
    }

    enum CodingKeys: String, CodingKey {
        case name, lineNumber, executionCount
    }

    required init(from decoder: Decoder) throws {
        let cnt = try decoder.container(keyedBy: CodingKeys.self)
        lineNumber = try cnt.decode(UInt.self, forKey: .lineNumber)
        name = try cnt.decode(String.self, forKey: .name)
        executionCount = try cnt.decode(UInt.self, forKey: .executionCount)

        try super.init(from: decoder)
    }
}
