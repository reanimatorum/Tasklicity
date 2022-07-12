//
//  ExpirationDateViewController.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 18.02.2022.
//

import UIKit

class ExpirationDateViewController: UIViewController {
	
	private var expirationDateCounter = ExpirationDateCounter()
	
	@IBOutlet var dateLabel: UILabel! {
		didSet {
			dateLabel.text = expirationDateCounter.dateFromDatePicker.formatted(date: .long, time: .omitted)
		}
	}
	@IBOutlet var datePicker: UIDatePicker!
	@IBOutlet var daysBeforeTextField: UITextField!
	
	@IBAction func countDaysBeforeExpiration(_ sender: UIButton) {
		guard let daysCounter = daysBeforeTextField.text,
			  let tempDateCounter = Int(daysCounter) else { return }

		expirationDateCounter.lastDay = expirationDateCounter.expirationCounter(startDate: expirationDateCounter.dateFromDatePicker, days: tempDateCounter)
		dateLabel.text = expirationDateCounter.lastDay.formatted(date: .long,
																 time: .omitted)
	}

	@IBAction func datePickerValueIsChanged(_ sender: UIDatePicker) {
		expirationDateCounter.dateFromDatePicker = sender.date
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.view.endEditing(true)
	}

}
