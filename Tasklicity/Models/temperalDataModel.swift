//
//  temperalDataModel.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 12.07.2022.
//

import CoreData
import UIKit

class DataModelInCode {
	public var context: NSManagedObjectContext
	public var group: Group
	public var task: Task
	
	init(context: NSManagedObjectContext, group: Group, task: Task) {
		self.context = context
		self.group = group
		self.task = task
	}
	
	func saveChangedContext(tableView: UITableView) {
		let tasks = self.group.tasks?.mutableCopy() as! NSMutableOrderedSet
		tasks.add(task)
		self.group.tasks = tasks
		
		do {
			try self.context.save()
			tableView.reloadData()
		} catch let error as NSError {
			print("ДА ЁБАНЫЙ  РОТ! \(error)")
		}
	}
}
