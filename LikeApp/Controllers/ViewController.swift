//
//  ViewController.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 05/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var LikeTableView: UITableView!
    
  //  var likeSaver = [LikeModel]()
    var likeSaver2 = [LikeClass]()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("IsEmpty = \(likeSaver2.isEmpty)")
        
        fetchingDataFromCore()
  
        PostingNotification()
      
        
    }
    
    func PostingNotification(){
        NotificationCenter.default.addObserver(forName: Constants.sharedInstance, object: nil, queue: nil, using: {_ in
            //var likeSUb = [LikeClass]()
            print("Cell Id = \(Constants.sharedInt.id)")
           // likeSUb = self.likeSaver2
            //let data2 = LikeClass(context: PersistanceService.context)
          // likeSUb[Constants.sharedInt.id].likecount += 1
             self.likeSaver2[Constants.sharedInt.id].likecount += 1
            
          //  self.likeSaver2 = likeSUb
            PersistanceService.saveContext()
            self.LikeTableView.reloadData()
        })
    }
    
    func fetchingDataFromCore() {
        
        let fetchRequest: NSFetchRequest<LikeClass> = LikeClass.fetchRequest()
       // fetchRequest.sortDescriptors = [NSSortDescriptor(key: "likecount", ascending: true)]
       // fetchRequest.sortDescriptors = [NSS]
        do {
            print("FetchingWotking")
            let likes =  try PersistanceService.context.fetch(fetchRequest)
            
            if likes.isEmpty {
                print(" likes.isEmpty = \( likes.isEmpty)")
                addLikes()
            }else{
                self.likeSaver2 = likes
                self.LikeTableView.reloadData()
            }
            
           
        } catch {}
        
    }
    
    func addLikes() {
        print("addLikes Working")
        //likeSaver2.removeAll()
        
        for i in 0..<10 {
            
            print("FORCount = \(i)")
            
            let data2 = LikeClass(context: PersistanceService.context)
            data2.likecount = 0
            likeSaver2.append(data2)
            PersistanceService.saveContext()
        }
        
        LikeTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }


}

extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeSaver2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableViewCell", for: indexPath) as! LikeTableViewCell
        
        cell.LikeCountLabel.text = String(likeSaver2[indexPath.row].likecount)
        
        return cell
    }
    
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LikeGiverViewController") as! LikeGiverViewController
        
        vc.id = indexPath.row
        
        present(vc, animated: true, completion: nil)
    }
    
}

