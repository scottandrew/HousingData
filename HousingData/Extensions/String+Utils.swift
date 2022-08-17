//
//  String+Utils.swift
//  HousingData
//
//  Created by Scott Andrew on 8/5/22.
//

import Foundation

enum StringConversionError: Error {
    case canNotConvertTo(type: String)
}

extension String {
    func toInt() throws -> Int {
        if let value = Int(self) {
            return value;
        }
        
        throw StringConversionError.canNotConvertTo(type: String(describing: Int.self))
    }
    
    func toDouble() throws -> Double {
        if let value = Double(self) {
            return value;
        }
        
        throw StringConversionError.canNotConvertTo(type: String(describing: Double.self))
    }
}
