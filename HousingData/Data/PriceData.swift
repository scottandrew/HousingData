//
//  MedianPrice.swift
//  HousingData
//
//  Created by Scott Andrew on 8/4/22.
//

import Foundation

struct PriceData: Identifiable {
    let date: Date
    let value: Double?
    
    var id: Date { date }
}
