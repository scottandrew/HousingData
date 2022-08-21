//
//  HousingData.swift
//  HousingData
//
//  Created by Scott Andrew on 8/5/22.
//

import Foundation

struct RegionData: Identifiable {
    enum RegionType: String {
        case metro = "Msa"
        case country = "Country"
    }
    
    enum ColumnIndex: Int {
        case id
        case rank
        case name
        case type
        case state
        case firstDate
    }
    
    let id: Int
    let rank: Int
    let type: RegionType
    let name: String
    let state: String?
    let values: [PriceData]
    
    init(data: [String?], dates: [Date]) throws {
        self.id = try data[ColumnIndex.id.rawValue]!.toInt()
        self.rank = try data[ColumnIndex.rank.rawValue]!.toInt()
        self.name = data[ColumnIndex.name.rawValue]!
        self.type = RegionType(rawValue: data[ColumnIndex.type.rawValue] ?? "Msa") ?? .metro
        self.state = data[ColumnIndex.state.rawValue]
        
        let dateStartIndex = ColumnIndex.firstDate.rawValue
        let amounts = data[dateStartIndex ..< data.count]
        
        values = zip(dates, amounts).map { (date, amount) in
           return PriceData(date: date, value: try? amount?.toDouble())
        }
    }
}
