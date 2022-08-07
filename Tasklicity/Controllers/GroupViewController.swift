//
//  GroupViewController.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 09.02.2022.
//

import UIKit
import CoreData

class GroupViewController: UITableViewController {
	
	var coreDataModel = DataModelInCode(context: NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType), group: Group(), task: Task())
//	var context: NSManagedObjectContext!
	var groups: [Group] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
		
		do {
			let results = try coreDataModel.context.fetch(fetchRequest)
			groups = results
		} catch let error as NSError {
			print(error)
		}
    }

	@IBAction func addGroupButtonPressed(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "Add group",
												message: "Write your group name here",
												preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = "Type here"
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let doneAction = UIAlertAction(title: "Done", style: .default) { action in
			let text = alertController.textFields?.first?.text
			self.groups.append(Group(context: self.coreDataModel.context))
			self.groups.last?.groupName = text
			
			do {
				try self.coreDataModel.context.save()
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
		return groups.count
    }

    override func tableView(_ tableView: UITableView,
							cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskGroupCell",
												 for: indexPath)
		
		var configuration = cell.defaultContentConfiguration()
		configuration.text = groups[indexPath.row].groupName
		cell.contentConfiguration = configuration
		
        return cell
    }

    override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		coreDataModel.context.delete(groups[indexPath.row])
		groups.remove(at: indexPath.row)
		
		do {
			try coreDataModel.context.save()
			tableView.reloadData()
		} catch let error as NSError {
			print(error)
		}
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let indexPath = tableView.indexPathForSelectedRow {
			let taskViewController = segue.destination as! TaskViewController
			taskViewController.group = groups[indexPath.row]
			taskViewController.context = coreDataModel.context
		}
    }

}

//TODO: - Needs to be refactored
