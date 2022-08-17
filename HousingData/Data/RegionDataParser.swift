//
//  RegionDataParser.swift
//  HousingData
//
//  Created by Scott Andrew on 8/6/22.
//

import Foundation
import EasyCSV

enum RegionDataParserError : Error {
    case missingDate
}

struct RegionDataParser {
    func parse(url: URL) async throws -> [RegionData]  {
        let csvParser = EasyCSV(url: url)
        var dates = [Date]()
        var data = [RegionData]()
        
        for try await line in csvParser {
            if line.lineNumber == 0 {
                dates = try extractDateColumns(from: line.data)
            } else {
                data.append(try RegionData(data: line.data, dates: dates))
            }
        }
        
        return data;
    }
    
    private func extractDateColumns(from data: [String?]) throws -> [Date] {
        let startingDateIndex = RegionData.ColumnIndex.firstDate.rawValue
        let columnsToConvert = data[startingDateIndex ..< data.count]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return try columnsToConvert.map {dateString  in
            guard let dateString else {
                throw RegionDataParserError.missingDate
            }
            
            return dateFormatter.date(from: dateString)!
        }
    }
}
