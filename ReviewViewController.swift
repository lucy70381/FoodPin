//
//  ReviewViewController.swift
//  HelloWorld
//
//  Created by 楊惠如 on 2021/3/24.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var ratingButton1: UIButton!
    @IBOutlet var ratingButton2: UIButton!
    @IBOutlet var ratingButton3: UIButton!
    
    
    var rating: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //圖片模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //圖片縮小
        let scale = CGAffineTransform.identity.scaledBy(x: 0.0, y: 0.0)
        
        //圖片移動
        var translate = CGAffineTransform.identity.translatedBy(x: 0, y: -500)
        
        ratingButton1.transform = scale.concatenating(translate)
        
        translate = CGAffineTransform.identity.translatedBy(x: 0, y: 200)
        ratingButton2.transform = scale.concatenating(translate)
        
        translate = CGAffineTransform.identity.translatedBy(x: 0, y: 300)
        ratingButton3.transform = scale.concatenating(translate)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //圖片動畫
//        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
//            self.ratingStackView.transform = CGAffineTransform.identity
//        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: [], animations: {
            self.ratingButton1.transform = CGAffineTransform.identity
            self.ratingButton2.transform = CGAffineTransform.identity
            self.ratingButton3.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @IBAction func ratingSelected(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            rating = "dislike"
        case 3:
            rating = "good"
        case 5:
            rating = "great"
        default:
            rating = ""
        }
        
        performSegue(withIdentifier: "unwindToDetailView", sender: sender)
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
