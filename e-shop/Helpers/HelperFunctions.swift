//
//  HelperFunctions.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 06.08.2024.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    
    let correncyFormatter = NumberFormatter()
    correncyFormatter.usesGroupingSeparator = true
    correncyFormatter.numberStyle = .currency
    correncyFormatter.locale = Locale.current
    
    return correncyFormatter.string(from: NSNumber(value: number)) ?? "0.00"
}
