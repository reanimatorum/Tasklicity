//
//  TaskViewController.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 09.02.2022.
//

import UIKit
import CoreData

class TaskViewController: UITableViewController {

	var group: Group!
	var context: NSManagedObjectContext!
	private let currentDate = Date()
		
	override func viewDidLoad() {
        super.viewDidLoad()
	}

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "Add task",
												message: "Write your task here",
												preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = "Type here"
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let doneAction = UIAlertAction(title: "Done", style: .default) { [self] action in
			let task = Task(context: self.context)
			task.taskName = alertController.textFields?.first?.text
			task.taskIsDone = false
			task.taskDate = Date()
			
			let tasks = self.group.tasks?.mutableCopy() as? NSMutableOrderedSet
			tasks?.add(task)
			self.group.tasks = tasks
			
			do {
				try self.context.save()
				self.tableView.reloadData()
			} catch let error as NSError {
				print(error)
			}
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(doneAction)
		
		present(alertController, animated: true)
	}
	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
							numberOfRowsInSection section: Int) -> Int {
		return group.tasks?.count ?? 0
    }
	
    override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell",
												 for: indexPath) as! CustomTableViewCell
		cell.delegate = self
		guard let task = group.tasks?[indexPath.row] as? Task else { return cell }
		cell.taskLabel.text = task.taskName
		cell.indexPath = indexPath.row
		cell.task = task
		if task.taskIsDone == true {
			cell.listRowStateButton.setImage(UIImage(systemName: "circle.inset.filled"),
											 for: .normal)
		} else {
			cell.listRowStateButton.setImage(UIImage(systemName: "circle"),
											 for: .normal)
		}
		
		let calendar = Calendar.current
		guard let taskDate = task.taskDate else { return cell }
		let firstDate = calendar.dateComponents(in: .current, from: taskDate)
		let secondDate = calendar.dateComponents(in: .current, from: currentDate)
		
		if firstDate.day != secondDate.day {
			task.taskIsDone = false
			task.taskDate = taskDate + 86400
			
			do {
				try context.save()
				tableView.reloadData()
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		} else { return cell }
		
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let task = group.tasks?[indexPath.row] as? Task else { return }
		
		let alertController = UIAlertController(title: "Edit task",
												message: "Write your task here",
												preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.text = task.taskName
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let doneAction = UIAlertAction(title: "Done", style: .default) { [self] action in
			task.taskName = alertController.textFields?.first?.text
			
			let tasks = self.group.tasks?.mutableCopy() as? NSMutableOrderedSet
			tasks?[indexPath.row] = task
			self.group.tasks = tasks
			
			do {
				try self.context.save()
				self.tableView.reloadData()
			} catch let error as NSError {
				print(error)
			}
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction(doneAction)
		
		present(alertController, animated: true)
	}

    override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		guard let task = group.tasks?[indexPath.row] as? Task,
			  editingStyle == .delete else { return }
		context.delete(task)

		do {
			try context.save()
			tableView.reloadData()
		} catch let error as NSError {
			print(error)
		}
	}

}

extension TaskViewController: CustomTableViewCellDelegate {
	func taskIsChanged(_ cell: CustomTableViewCell) {
		guard let unwrappedTask = cell.task else { return }
		guard let task = group.tasks?[cell.indexPath] as? Task else { return }
		task.taskIsDone = unwrappedTask.taskIsDone
		
		do {
			try context.save()
		} catch let error as NSError {
			print(error)
		}
		
		if cell.task.taskIsDone == false {
			cell.task.taskIsDone = true
		} else if cell.task.taskIsDone == true{
			cell.task.taskIsDone = false
		}
		
		tableView.reloadData()
	}
}

//TODO: - Needs to be refactored
