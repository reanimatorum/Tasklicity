//
//  AlertModel.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 07.08.2022.
//

import UIKit
import CoreData

protocol AlertControllerDataTransferDelegate {
	func transfer(contextToTransfer: NSManagedObjectContext)
}

public enum AlertType {
	case editGroupsList
	case editTasksList
	case editCurrentTask
}

//public enum DataObjects {
//	case Group
//	case Task
//}

class AlertController {
	var contextDataFetcher = DataModelInCode(context: NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType), group: Group(), task: Task(), groupStorage: [Group]())
	
//	typealias CDObjects <Group, Task> = [Group, Task]

	let title: String
	let message: String
	let preferredStyle: UIAlertController.Style
	var transitionClosure: (() -> ())?
		
	func performAlertWindow(tableView: UITableView) -> UIAlertController {
		
		let alertController = UIAlertController(title: title,
												message: message,
												preferredStyle: preferredStyle)
		alertController.addTextField { textField in
			textField.placeholder = "Type here"
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let doneAction = UIAlertAction(title: "Done", style: .default) { action in
			let text = alertController.textFields?.first?.text
			self.contextDataFetcher.groupsStorage.append(Group(context: self.contextDataFetcher.context))
			self.contextDataFetcher.groupsStorage.last?.groupName = text
			guard let temperalNSObject = self.contextDataFetcher.groupsStorage.last else { return }
			self.contextDataFetcher.context.insert(temperalNSObject)
			do {
				try self.contextDataFetcher.context.save()
			} catch let error as NSError {
				print("ебанашка \(error)")
			}
//			self.contextDataFetcher.transferClosure = {
//
//			}
			self.contextDataFetcher.saveChangedContext(contextType: .editGroupsList)
//			do {
//				try context.save()
//				NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Reload!"), object: nil)
//			} catch let error as NSError {
//				print(error)
//			}
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(doneAction)

		return alertController
		
	}
	
	init(title: String, message: String, preferredStyle: UIAlertController.Style) {
		
		self.title = title
		self.message = message
		self.preferredStyle = preferredStyle		
	}

}

extension AlertController {
	
}



