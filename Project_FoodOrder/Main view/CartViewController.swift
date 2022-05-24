//
//  CartViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 23/05/2022.
//

import UIKit
import JGProgressHUD

class CartViewController: UIViewController {

    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var cartTotalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    
    //MARK: Vars
    var cart: Cart?
    var allItems: [Item] = []
    var purchasedItemIds : [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Muser.currentUser() != nil{
            loadCartFromFirestore()
            
        } else{
            self.updateTotalLabels(true)
        }
    }
    
    //Press button check out
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        if Muser.currentUser()!.onboard{
            tempFunction()
            
            addItemsToPurchaseHistory(self.purchasedItemIds)
            emptyTheCart()
            self.hud.textLabel.text = "Thank You for order"
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay:  2.0)
        }
        else{
            self.hud.textLabel.text = "Please complete you profile!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay:  2.0)
        }
    }
    
    //MARK: Download cart
    private func loadCartFromFirestore(){
        downloadCartFromFỉrestore(Muser.currentId()){ (cart) in
            self.cart = cart
            self.getCartItems()        }
    }
    
    private func getCartItems(){
        if cart != nil{
            downloadItems(cart!.itemIds){(allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Helper function
    
    func tempFunction(){
        for item in allItems{
            purchasedItemIds.append(item.id)
        }
    }
    private func updateTotalLabels(_ isEmty: Bool){
        if isEmty{
            totalItemsLabel.text = "0"
            cartTotalPriceLabel.text = returnCartTotalPrice()
        }
        else{
            totalItemsLabel.text = "\(allItems.count)"
            cartTotalPriceLabel.text = returnCartTotalPrice()
        }
        checkoutButtonStatusUpdate()
        
    }
    
    private func returnCartTotalPrice() -> String{
        var totalPrice = 0.0
        for item in allItems{
            totalPrice += item.price
        }
        return "Total price: " + convertTocurrency(totalPrice)
    }
    
    private func emptyTheCart(){
        purchasedItemIds.removeAll()
        allItems.removeAll()
        tableView.reloadData()
        
        cart!.itemIds = []
        
        updateCartInFirestore(cart!, withValue: [KITEMIDS : cart!.itemIds]){ (error) in
            
            if error != nil{
                print("Error updating cart ", error!.localizedDescription)
            }
            self.getCartItems()
        }
    }
    
    private func addItemsToPurchaseHistory(_ itemIds: [String]){
        if Muser.currentUser() != nil{
            let newItemIds = Muser.currentUser()!.purchasedItemIds + itemIds
            
            updateCurrentUserInFirestore(withValues: [KPURCHASEDITEMIDS : newItemIds]) { (error) in
                if error != nil{
                    print("Error adding purchased items", error!.localizedDescription)
                }
            }
        }
    }
    
    //MARK: Navigation
    private func showItemView(withItem: Item){
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: Control checkoutButton
    private func checkoutButtonStatusUpdate(){
        checkoutButtonOutlet.isEnabled = allItems.count > 0
        if checkoutButtonOutlet.isEnabled{
            checkoutButtonOutlet.backgroundColor = .red
        }
        else{
            disableCheoutButton()
        }
    }
    
    private func disableCheoutButton(){
        checkoutButtonOutlet.isEnabled = false
        checkoutButtonOutlet.backgroundColor = .gray
    }
    
    private func removeItemFromCart(itemId: String){
        for i in 0..<cart!.itemIds.count {
            if itemId == cart!.itemIds[i]{
                cart!.itemIds.remove(at: i)
                return
            }
        }
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.genrateCell(allItems[indexPath.row])
        return cell
    }
    
    //MARK: UITable Delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let itemToDelet = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromCart(itemId: itemToDelet.id)
            
            updateCartInFirestore(cart!, withValue: [KITEMIDS: cart!.itemIds]){(error) in
                if error != nil{
                    print("error updating the cart", error!.localizedDescription)
                }
                self.getCartItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
    
    
}
