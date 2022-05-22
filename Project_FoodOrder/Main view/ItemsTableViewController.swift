//
//  ItemsTableViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 17/05/2022.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    //MARK: Vars
    var category: Category?
    
    var itemArray: [Item] = []
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        self.title = category?.name

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil{
            //download items
            loadItems()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.genrateCell(itemArray[indexPath.row])

        // Configure the cell...

        return cell
    }
    
    //MARK: - Table Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSeg"{
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
    }
    
    private func showItemView(_ item: Item){
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: Load items
    private func loadItems(){
        downloadItemsFromFirebase(category!.id){(allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
    

}
