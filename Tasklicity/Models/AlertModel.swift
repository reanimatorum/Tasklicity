//
//  AlertModel.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 07.08.2022.
//

import UIKit
import CoreData

struct AlertController {
	let title: String
	let message: String
	let preferredStyle: UIAlertController.Style
	var groups: [Group]
	
	mutating func performAlert(tableView: UITableView, context: NSManagedObjectContext) {
		let alertController = UIAlertController(title: title,
												message: message,
												preferredStyle: preferredStyle)
		alertController.addTextField { textField in
			textField.placeholder = "Type here"
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let doneAction = UIAlertAction(title: "Done", style: .default) { action in
			let text = alertController.textFields?.first?.text
			self.groups.append(Group(context: context))
			self.groups.last?.groupName = text
			
			do {
				try context.save()
				tableView.reloadData()
			} catch let error as NSError {
				print(error)
			}
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(doneAction)
		
		present(alertController, animated: true)
	}
}
