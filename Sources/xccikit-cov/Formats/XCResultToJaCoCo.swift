//
//  XCResultToJaCoCo.swift
//  xccikit-cov
//
//  Created by Tristian Azuara on 11/13/20.
//

import Foundation

func jacoco(from xcresult: XCResultCov, target: String? = nil) -> JaCoCo {
    .init(name: target ?? xcresult.targets.first(where: {$0.name == target })?.name ?? "",
          sessionInformation: .init(id: "", startDate: Date(), dumpDate: Date()))
}
