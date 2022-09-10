//
//  Restaurant.swift
//  HelloWorld
//
//  Created by 楊惠如 on 2021/3/22.
//

import Foundation
import CoreData

class Restaurant:NSManagedObject {
    @NSManaged var name: String
    @NSManaged var type: String
    @NSManaged var image: Data?
    @NSManaged var location: String
    @NSManaged var isVisited: Bool
    @NSManaged var phoneNumber: String?
    @NSManaged var rating: String?
    
//    init(name: String, type: String, location: String, phoneNumber: String, image: Data, isVisited: Bool) {
//        self.name = name
//        self.type = type
//        self.image = image
//        self.location = location
//        self.isVisited = isVisited
//        self.phoneNumber = phoneNumber
//    }
//
//    func setRating(rating: String) -> Void {
//        self.rating = rating
//    }
}
