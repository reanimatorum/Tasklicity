//
//  ExpirationDateViewController.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 18.02.2022.
//

import UIKit

class ExpirationDateViewController: UIViewController {
	
	var expirationDateCounter = ExpirationDateCounter()
	var startDate = Date()
	
	@IBOutlet var dateLabel: UILabel! {
		didSet {
			dateLabel.text = expirationDateCounter.dateFromDatePicker.formatted(date: .long, time: .omitted)
		}
	}
	@IBOutlet var datePicker: UIDatePicker!
	@IBOutlet var daysBeforeTextField: UITextField!
	
	@IBAction func countDaysBeforeExpiration(_ sender: UIButton) {
		guard let daysCounter = daysBeforeTextField.text else { return }
		guard let tempDateCounter = Int(daysCounter) else { return }
		expirationDateCounter.lastDay = expirationDateCounter.expirationCounter(startDate: expirationDateCounter.dateFromDatePicker, days: tempDateCounter)
		dateLabel.text = expirationDateCounter.lastDay.formatted(date: .long, time: .omitted)
		print("\(String(describing: expirationDateCounter.lastDay))")
	}

	@IBAction func datePickerValueIsChanged(_ sender: UIDatePicker) {
		startDate = sender.date
	}
	
}
