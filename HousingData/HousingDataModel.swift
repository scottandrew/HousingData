//
//  HousingDataModel.swift
//  HousingData
//
//  Created by Scott Andrew on 8/18/22.
//

import Foundation
import SwiftUI

@MainActor
class HousingDataModel : ObservableObject {
    @Published private (set) var data = [RegionData]()
    
    func sync() async throws {
        var url: URL
        
        // If we are running a preview we will load our test data.
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
            url = Bundle.main.url(forResource: "PreviewData", withExtension: "csv")!
        }
        else {
            let address = "https://files.zillowstatic.com/research/public_csvs/zhvi/Metro_zhvi_uc_sfr_tier_0.33_0.67_sm_sa_month.csv?t=\(Int(Date().timeIntervalSince1970))"
            url = URL(string: address)!
        }
        
        data = try await RegionDataParser().parse(url: url);
    }
}
