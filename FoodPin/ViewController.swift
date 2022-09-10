//
//  ViewController.swift
//  HelloWorld
//
//  Created by 楊惠如 on 2021/3/15.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    // hide stausbar
    override var prefersStatusBarHidden: Bool {
        return false
    }

    
    @IBAction func button1(sender: UIButton) {
        let dic = ["😀": "Smile", "🤔": "Think", "🤣": "Joy", "😡": "Angry"]
        if let emoji = sender.titleLabel?.text {
            let alert = UIAlertController(title: "Meaning", message: dic[emoji], preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    //Ch 8
    let restaurantsName = ["barrafina", "bourkestreetbakery", "cafedeadend", "cafeloisl", "cafelore", "confessional", "donostia", "fiveleaves", "forkeerestaurant", "grahamavenuemeats", "haighschocolate", "homei", "palominoespresso", "petiteoyster", "posatelier", "royaloak", "teakha", "thaicafe", "traif", "upstate" , "wafflewolf"]

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath)
        
        let name = restaurantsName[indexPath.row]
        cell.imageView?.image = UIImage(named: name)
        cell.textLabel?.text = name
        
        return cell
    }
}

