//
//  ExpirationDateViewController.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 18.02.2022.
//

import UIKit

class ExpirationDateViewController: UIViewController {
	
	var expirationDateCounter = ExpirationDateCounter()
	
	@IBOutlet var dateLabel: UILabel! {
		didSet {
			dateLabel.text = expirationDateCounter.currentDate.formatted(date: .long, time: .omitted)
		}
	}
	@IBOutlet var datePicker: UIDatePicker!
	@IBOutlet var daysBeforeTextField: UITextField!
	
	@IBAction func countDaysBeforeExpiration(_ sender: UIButton) {
		guard let daysCounter = daysBeforeTextField.text else { return }
		guard let tempDateCounter = Int(daysCounter) else { return }
		expirationDateCounter.lastDay = expirationDateCounter.expirationCounter(startDate: datePicker.date,
																				days: tempDateCounter)
		dateLabel.text = expirationDateCounter.lastDay.formatted(date: .long, time: .omitted)
		print("\(String(describing: expirationDateCounter.lastDay))")
	}


}
