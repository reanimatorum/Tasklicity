//
//  CustomTableViewCell.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 09.02.2022.
//

import UIKit

protocol CustomTableViewCellDelegate: NSObject {
	func taskIsChanged(_ cell: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {
	
	weak var delegate: CustomTableViewCellDelegate?
	var indexPath = Int()
	var task: Task!
	
	@IBOutlet var listRowStateButton: UIButton!
	@IBOutlet var taskLabel: UILabel!
	
	@IBAction func listRowStateButtonPressed(_ sender: UIButton) {
		delegate?.taskIsChanged(self)
	}
	
}
