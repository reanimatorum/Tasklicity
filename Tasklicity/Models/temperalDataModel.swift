//
//  temperalDataModel.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 12.07.2022.
//

import CoreData
import UIKit
//
//protocol ApplicationDatabaseDelegate {
//	var delegate: AlertController { get set }
//}

class DataModelInCode {

	public var context: NSManagedObjectContext
	public var group: Group
	public var task: Task
	public var groupsStorage: [Group]
	public var transferClosure: (() -> ())?
	
	init(context: NSManagedObjectContext, group: Group, task: Task, groupStorage: [Group]) {
		self.context = context
		self.group = group
		self.task = task
		self.groupsStorage = groupStorage
	}

	
	func saveChanges() {
		do {
			try context.save()
			//Update TableView here
		} catch let error as NSError {
			print("ДА ЁБАНЫЙ  РОТ! \(error)")
		
	}
	}
	
	func saveChangedContext(contextType: AlertType) {
		switch contextType {
		case .editGroupsList:
			saveChanges()
		case .editTasksList:
			let tasks = self.group.tasks?.mutableCopy() as! NSMutableOrderedSet
			tasks.add(task)
			self.group.tasks = tasks
			saveChanges()
		case .editCurrentTask:
			return
		}
		
		
			
		
	}
}
