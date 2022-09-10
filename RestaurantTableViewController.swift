//
//  TableViewTableViewController.swift
//  HelloWorld
//
//  Created by 楊惠如 on 2021/3/18.
//

import UIKit
import CoreData


class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    @IBOutlet var tableview: UITableView!
    
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var searchController: UISearchController!
    
    
    var restaurants: [RestaurantMO] = []
    var searchResults: [RestaurantMO] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        tableview.estimatedRowHeight = 120.0
//        tableview.rowHeight = UITableView.automaticDimension
        
        // 搜尋欄
        searchController = UISearchController(searchResultsController:nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        tableView.tableHeaderView = searchController.searchBar
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // 抓CoreData資料
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    restaurants = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //教學導引
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        let hasViewdWalkthrough = defaults.bool(forKey: "hasViewdWalkthrough")
        
        if hasViewdWalkthrough {
            return
        }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") {
            self.present(pageViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }

    // MARK: - Table view data source
    
    
    //搜尋 UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText: searchText)
            tableview.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = restaurants.filter({
            (restaurant: RestaurantMO) -> Bool in
            let nameMatch = restaurant.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
            let locationMatch = restaurant.location?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
            return nameMatch != nil || locationMatch != nil
        })
    }
    
    
    
    
    // CoreData實作方法 NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller:
    NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any, at indexPath: IndexPath?, for type:
    NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with:.fade)
                }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
               }
            case .update:
                if let indexPath = indexPath {
                    tableView.reloadRows(at: [indexPath], with: .fade)
               }
            default:
                tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    func controllerDidChangeContent(_ controller:
    NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    @IBAction func unwindToHomeScreen(_ sender: UIStoryboardSegue) {
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifer = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! RestaurantTableCell
        
        // 照片圓弧調整
        cell.ShaunVIew.layer.cornerRadius = 30
        
        cell.ShaunVIew.clipsToBounds = true
        
        let index = indexPath.row
        let restaurant = searchController.isActive ? searchResults[index] : restaurants[index]
        cell.ShaunVIew.image = UIImage(data: restaurant.image!)
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
        return cell
    }
    
    //Ch 10 Alert與視窗互動
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        //閉包 (Closure)
//        let callActionHandler = {(action: UIAlertAction!) -> Void in
//            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, not support now", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            
//            alertMessage.addAction(alertAction)
//            self.present(alertMessage, animated: true, completion: nil)
//        }
//        let callAction = UIAlertAction(title: "Call", style: .default, handler: callActionHandler)
//        let isVisited = self.restaurants[indexPath.row].isVisited
//        
//        let isVisitedAction = UIAlertAction(title: isVisited ? "I haven't been here" : "I've been here", style: .default, handler: {
//            (action: UIAlertAction!) -> Void in
//            
//            self.restaurants[indexPath.row].isVisited = !isVisited
//            
//            let cell = tableView.cellForRow(at: indexPath)
//            cell?.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
//        })
//        
//        optionMenu.addAction((isVisitedAction))
//        optionMenu.addAction(callAction)
//        optionMenu.addAction(cancelAction)
//        self.present(optionMenu, animated: true, completion: nil)
//        
//        tableView.deselectRow(at: indexPath, animated: false)
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//
//            let index = indexPath.row
//            restaurantNames.remove(at: index)
//            restaurantLocations.remove(at: index)
//            restaurantTypes.remove(at: index)
//            restaurantIsVisited.remove(at: index)
//
////            tableView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .fade)  //.Right .Left .Top
//
//            print("Total items: \(restaurantNames.count)")
//            for name in restaurantNames {
//                print(name)
//            }
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    //Ch 11 自訂滑動按鈕
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let index = indexPath.row
        
        // 社群分享
        let shareAction = UIContextualAction(style: .destructive, title: "Share", handler: {
            (action, view, completionHandler) in
            
            let restaurant = self.restaurants[indexPath.row]
            let defaultText = "Just checking in at " + restaurant.name!
            
            // 分享相片
            if let imageToShare = UIImage(named: restaurant.name!) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            } else {
                let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
            
        })
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {
            
            (action, view, completionHandler) in
                        
//            self.restaurants.remove(at: index)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            completionHandler(true)
            
            // CoreData刪除
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                appDelegate.saveContext()
            }
        })
        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor.lightGray
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return configuration
    }
    
  

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let index = indexPath.row
                let destinationController = segue.destination as! RestaurantDetailViewController
                
                let restaurant = searchController.isActive ? searchResults[index] : restaurants[index]
//                destinationController.restaurantName = restaurant.name
//                destinationController.restaurantLocation = restaurant.location
//                destinationController.restaurantType = restaurant.type
                destinationController.restaurant = restaurant
            }
        }
    }
    

    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let shareAction = UIContextualAction(style: .default, title: "Share", handler: {
//            (action, indexPath) -> Void in
//
//            let defaultText = "Just checking in at " + self.restaurantNames[indexPath.row]
//            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
//            self.present(activityController, animated: true, completion: nil)
//        })
//
//        let deleteAction = UIContextualAction(style: .default, title: "Delete", handler: {
//
//            (action, indexPath) -> Void in
//
//            let index = indexPath.row
////            restaurantNames.remove(at: index)
//            self.restaurantLocations.remove(at: index)
//            self.restaurantTypes.remove(at: index)
//            self.restaurantIsVisited.remove(at: index)
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//        })
//
//        return [deleteAction, shareAction]
//    }
    

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
}
