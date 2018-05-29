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
    
    // table gets connected to the uiviewcontroller
    @IBOutlet weak var LikeTableView: UITableView!
    
    var providersAPI = APIService()
    var likeSaver2 = [LikeClass]()
    
    var modelContent = [ModelContents]()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        calllingURl()
       // callBundle()
    
    }
    
//    func callBundle(){
//        if let filepath = Bundle.main.path(forResource: "Info", ofType: "plist") {
//            do {
//                let contents = try String(contentsOfFile: filepath)
//                print("contents = \(contents)")
//            } catch {
//                print("contents could not be loaded")
//                // contents could not be loaded
//            }
//        } else {
//             print("example.txt not found!")
//            // example.txt not found!
//        }
//    }
    
    func calllingURl() {
        
        providersAPI.getDataWith { (values) in
            
            switch values {
            case .Success(let data):
                
                
                self.jsonResultParse(data as AnyObject)
            case .Error(let message):
                print("Error = \(message)")
            }
            
        }
        
    }
    
    func jsonResultParse(_ json:AnyObject) {
        
        let JsonArray = json as! NSArray
        print("jsonaArray = \(JsonArray)")
        
        if JsonArray.count != 0 {
            
            for i:Int in 0 ..< JsonArray.count {
                
                let jObject = JsonArray[i] as! NSDictionary
                let uModelCont:ModelContents = ModelContents()
                
                uModelCont.artistName = (jObject["artistName"] as? String)
                uModelCont.artistUrl = (jObject["artistUrl"] as? String)
                modelContent.append(uModelCont)

            }
            LikeTableView.reloadData()
        }
        
        fetchingDataFromCore()
        PostingNotification()
        
    }
    
    //this function gets called from the the vc and adds the observer for Notification center for the name given in singletone and a
    func PostingNotification(){
        NotificationCenter.default.addObserver(forName: Constants.sharedInstance, object: nil, queue: nil, using: {_ in
    
            print("Cell Id = \(Constants.sharedInt.id)")
            self.likeSaver2[Constants.sharedInt.id].likecount += 1
            PersistanceService.saveContext()
            self.LikeTableView.reloadData()
            
        })
    }
    
    
    @IBAction func ToSearchVC(_ sender: UIBarButtonItem) {
        //SearchViewController
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
       let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
        
    }
    
    // function to fetch data
    func fetchingDataFromCore() {
        
        let fetchRequest: NSFetchRequest<LikeClass> = LikeClass.fetchRequest()
       
        do {
            print("FetchingWotking")
            let likes =  try PersistanceService.context.fetch(fetchRequest)
            
            if likes.isEmpty {
                print(" likes.isEmpty = \( likes.isEmpty)")
                //function to add likes
                addLikes()
            }else{
                self.likeSaver2 = likes
                self.LikeTableView.reloadData()
            }
            
           
        } catch {}
        
    }
    
    //this function is called if the like class is empty to fill in the '0' in  like label initially
    func addLikes() {
        print("addLikes Working")
        
        
        for i in 0..<modelContent.count {
            
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
        return modelContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableViewCell", for: indexPath) as! LikeTableViewCell
        
        cell.LikeCountLabel.text = String(likeSaver2[indexPath.row].likecount)
        cell.TopLineLabel.text = modelContent[indexPath.row].artistName
        cell.descTextView.text = modelContent[indexPath.row].artistUrl
        
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

