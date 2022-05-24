//
//  PurchasedHistoryTableViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 23/05/2022.
//

import UIKit

class PurchasedHistoryTableViewController: UITableViewController {

    //MARK: Vars
    var itemArray : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.genrateCell(itemArray[indexPath.row])

        return cell
    }
    
    //MARK: Load items
    private func  loadItems(){
        downloadItems(Muser.currentUser()! .purchasedItemIds) { (allItems) in
            self.itemArray = allItems
            print("We have \(allItems.count) purchased items")
            self.tableView.reloadData()
        }
    }
}
