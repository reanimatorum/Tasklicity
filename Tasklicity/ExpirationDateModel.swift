//
//  ExpirationDateModel.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 18.02.2022.
//

import Foundation

struct ExpirationDateCounter {

	var dateFromDatePicker = Date()
	var lastDay: Date!
	
	func expirationCounter(startDate: Date, days: Int) -> Date {
		let expirationDate = Date(timeInterval: TimeInterval(days * 86400), since: startDate)
		return expirationDate
	}
	
}
