//
//  GroupViewController.swift
//  Tasklicity
//
//  Created by Максим Казанцев on 09.02.2022.
//

import UIKit
import CoreData

class GroupViewController: UITableViewController {
	
	var context: NSManagedObjectContext!
	private var groups = [Group]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
		
		do {
			let results = try context.fetch(fetchRequest)
			groups = results
		} catch let error as NSError {
			print(error)
		}

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
			self.groups.append(Group(context: self.context))
			self.groups.last?.groupName = text
			
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		context.delete(groups[indexPath.row])
		groups.remove(at: indexPath.row)
		
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

    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let indexPath = tableView.indexPathForSelectedRow {
			let taskViewController = segue.destination as! TaskViewController
			taskViewController.group = groups[indexPath.row]
			taskViewController.context = context
		}
    }

}
