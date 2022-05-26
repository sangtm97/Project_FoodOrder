//
//  HelperFunction.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 22/05/2022.
//

import Foundation

func convertTocurrency(_ number: Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale(identifier: "vi-VN")
    
    return currencyFormatter.string(from: NSNumber(value: number))!
    
}
		
