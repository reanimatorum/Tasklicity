//
//  GroupViewController.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 09.02.2022.
//

import UIKit
import CoreData

class GroupViewController: UITableViewController {
	
	var coreDataModel = DataModelInCode(context: NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType), group: Group(), task: Task(), groupStorage: [Group]())
	var groups: [Group] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
		
		do {
			let results = try coreDataModel.context.fetch(fetchRequest)
			coreDataModel.groupsStorage = results
		} catch let error as NSError {
			print(error)
		}
//		NotificationCenter.default.addObserver(self,
//											   selector: #selector(reloadTableView),
//											   name: NSNotification.Name(rawValue: "Reload!"),
//											   object: .none)
    }

	@IBAction func addGroupButtonPressed(_ sender: UIBarButtonItem) {
		let alertWindowObject = AlertController(title: "Add group",
												message: "Enter group name here",
												preferredStyle: .alert)
		let alertWindow = alertWindowObject.performAlertWindow(tableView: super.tableView)
		self.coreDataModel.saveChangedContext(contextType: .editGroupsList)
		tableView.reloadData()
		
		present(alertWindow, animated: true)
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


extension GroupViewController {
	@objc func reloadTableView() {
			
		tableView.reloadData()
	}
}
//TODO: - Needs to be refactored
