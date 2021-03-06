//
//  ViewController.swift
//  LCYCoreDataHelperExample
//
//  Created by LiChunyu on 16/1/22.
//  Copyright © 2016年 leacode. All rights reserved.
//

import UIKit
import LCYCoreDataHelper
import CoreData

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: LCYCoreDataCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors  = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        collectionView.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: globalContext!, sectionNameKeyPath: nil, cacheName: "UserCache")
        
        collectionView.frc.delegate = collectionView
        
        do {
            try collectionView.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        print(User.fetchCoreDataModels().count)
        print(User.fetchCoreDataModels().last?.username)
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.collectionView.numberOfSections()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.numberOfItemsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCellId", forIndexPath: indexPath) as! UserCollectionViewCell
        
        let user: User = self.collectionView.frc.objectAtIndexPath(indexPath) as! User
        
        print(user.id)
        
        cell.usernameLabel.text = user.username
        
//        self.collectionView.frc
        
        return cell
    }
    
    // MRK: - CRUD
    
    @IBAction func addNewItem(sender: AnyObject) {
        
        if collectionView.frc.fetchedObjects?.count > 0 {
            let user = (self.collectionView.frc.fetchedObjects?.last)! as! User
            User.i = user.id + 1
        }
        
        User.insertCoreDataModel()
        
    }
    
    
    @IBAction func deleteLast(sender: AnyObject) {
        
        if collectionView.frc.fetchedObjects?.count > 0 {
            globalContext?.deleteObject((self.collectionView.frc.fetchedObjects?.last)! as! NSManagedObject)
        }
        
    }
    
    @IBAction func deleteAll(sender: AnyObject) {
        
        do {
            try coreDataHelper?.removeAll("User")
            NSFetchedResultsController.deleteCacheWithName("UserCache")
            try collectionView.frc.performFetch()
            collectionView.reloadData()
        } catch {
        
        }
        
    }
    
    

}

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    
}


