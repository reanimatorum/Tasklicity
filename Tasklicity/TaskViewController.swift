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
	let currentDate = Date()
		
	override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView,
							numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
