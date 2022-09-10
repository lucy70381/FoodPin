//
//  RestaurantDetailViewController.swift
//  HelloWorld
//
//  Created by 楊惠如 on 2021/3/22.
//

import UIKit
import CoreData

class RestaurantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var ratingButton: UIButton!
    
    
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = restaurant.name
        
        if let rating = restaurant.rating {
            ratingButton.setImage(UIImage(named: rating), for: .normal)
        } else {
            ratingButton.setImage(UIImage(named: "rating"), for: .normal)
        }
        
        
        restaurantImageView.image = UIImage(data: restaurant.image!)
        tableview.tableFooterView = UIView(frame: CGRect.zero) //移除多餘分隔線
        tableview.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableview.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as? MapViewController
//            destinationController?.restaurant = restaurant
        }
    }
    
    // CoreData更新
    @IBAction func close(_ segue: UIStoryboardSegue) {
        if let reviewViewController = segue.source as? ReviewViewController {
            if let rating = reviewViewController.rating {
                restaurant.rating = rating
                restaurant.isVisited = true
                ratingButton.setImage(UIImage(named: rating), for: .normal)
                
                if let appDelegate = (UIApplication.shared.delegate) as? AppDelegate {
                    appDelegate.saveContext()
                }
                
                tableview.reloadData()
            }
        }
        
        if let rating = segue.identifier {
            restaurant.isVisited = true
            print(rating)
        }
        
//        if let appDelegate = (UIApplication.shared.delegate) as? AppDelegate {
//            appDelegate.saveContext()
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        cell.backgroundColor = UIColor.clear
        
        
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = restaurant.isVisited ? "Yes" : "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        // Configure the cell...

        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
