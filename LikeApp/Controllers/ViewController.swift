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
    
    //calling the model file from like class created for COREDATA ie persistanty saving the data in a variable as Array type
    var likeSaver2 = [LikeClass]()
    
    // creating an instance to store an array of Model file of type ModelContents class
    var modelContent = [ModelContents]()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calling the function which calls the func from with the completion block from the APIService class.
        calllingURl()
       
    
    }
    

    
    func calllingURl() {
        
        // called the singleton to call the func of api calling with the completion block.
        APIService.sharedInstance.getDataWith { (values) in
            
            //"values" variable can have two case , .Success and .Error, .Success accepts generic data types and .Error accepts String Dataype.
            switch values {
            case .Success(let data):
                
                //Calling the func to send the "data" of type AnyObject class which is actually receving as [[String:Anyobject]] type
                self.jsonResultParse(data as AnyObject)
                
            case .Error(let message):
                //just prints the error as localizedDescription
                print("Error = \(message)")
            }
            
        }
  
    }
    
    
    // called from the "calllingURl()" func that receives data of AnyObject
    func jsonResultParse(_ json:AnyObject) {
        
        // converting the anyobject data type to Array type by using NSArray from the UIKit.
        let JsonArray = json as! NSArray
        print("jsonaArray = \(JsonArray)")
        
        //since its of type array you can use .count from NSArray class
        if JsonArray.count != 0 {
            
            // for loop is used to itterate through the elements of this JsonArray
            for i:Int in 0 ..< JsonArray.count {
                
                // since the elements are of NSDictionary type , each elements are stored in "jObject" constant
                let jObject = JsonArray[i] as! NSDictionary
                // creating an instance of type "ModelContents" class which has declared string properties
                let uModelCont:ModelContents = ModelContents()
                
                //calling the class properties of ModelContents() , we are storing the dictionary type elements from jObject by calling the content by using the keys and casting as "optional String" type to one of the property from ModelContents() class.
                uModelCont.artistName = (jObject["artistName"] as? String)
                uModelCont.artistUrl = (jObject["artistUrl"] as? String)
                
                // as you store to "uModelCont" of type "ModelContents()" we can append the stored content to the "modelContent" which is of type array - [ModelContents](). We can append the data to type [ModelContents]() at each loop count. The content of "uModelCont" will be over written (one way to split the content using keys and storing it in a temp varible of type "ModelContents" class).
                modelContent.append(uModelCont)

            }
            //after finishing the loop, reload the data to display data in the tableview.
            LikeTableView.reloadData()
        }
        
        // This is for the Like count display only, after the passing the data to uitableview , we called the func "fetchingDataFromCore()". this for persistance saving the number of like data. Check the function for more info.
        fetchingDataFromCore()
        
        // this func adds the observer in the notification center for name declared in the singletone Constans.sharedInstance which is struct named as "Constants".
        PostingNotification()
        
    }
    
    // function to fetch data while loading the app ie after calling viewdidload
    func fetchingDataFromCore() {
        
        // creates an instance of type  NSFetchRequest of type LikeClass which is of type NSManagedObject. NSManaged object has a func called "fetchRequest()".
        let fetchRequest: NSFetchRequest<LikeClass> = LikeClass.fetchRequest()
        
        // do catch method is called to catch an error if occured.
        do {
            print("FetchingWorking")
            // created an constant which calls the class "PersistanceService()" which calls the static variable of type "NSManagedObjectContext" called "context"(it returns a "persistentContainer" varible of type NSPersistenctContainer), which has a func called fetch request and accepts constructers of type "NSFetchRequest".
            let likes =  try PersistanceService.context.fetch(fetchRequest)
            
            // likes is of type array of Likeclass([LikeClass]).
            if likes.isEmpty {
                print(" likes.isEmpty = \( likes.isEmpty)")
                //if likes array is empty calls a function to add likes.(fresh new likes)
                addLikes()
            }else{
                //if not empty , likes count which is alwayes be there until app get uninstalled, get saved in the likeSaver2 variable of type array of LikeClass - [LikeClass]().
                self.likeSaver2 = likes
                
                //table gets reloaded after
                self.LikeTableView.reloadData()
            }
            
        } catch (let error){
            //to whats the error when "try PersistanceService.context.fetch(fetchRequest)"
            print("CoreData ERROR = \(error.localizedDescription)")
        }
        
    }
    
    //this function is called if the like class is empty to fill in the '0' like count in  like label initially
    func addLikes() {
        print("addLikes Working")
        
        //counts the number of likes array count needed according to content 
        for i in 0..<modelContent.count {
            
            print("FORCount = \(i)")
            //since the like class is of "NSManagedObject" class we can call the context parameter for the LikeClass and input context(oftype "NSManageObjectContext") of the PersistanceService class ie "NSManageObjectContext" to "NSManagedObject"
            let data2 = LikeClass(context: PersistanceService.context)
            data2.likecount = 0 // "likecount" is the "attribute" of the "entity" called "LikeClass"
            likeSaver2.append(data2) // append the data2 varaible to the likesaver2
            //then save the context using PersistanceService class ie  closing the lid after putting the data in the box
            PersistanceService.saveContext()
        }
        //
        LikeTableView.reloadData()
    }
    
    //this function gets called from the the vc and adds the observer for Notification center for the name given in singletone.
    func PostingNotification(){
        
        NotificationCenter.default.addObserver(forName: Constants.sharedInstance, object: nil, queue: nil, using: {_ in
    
            print("Cell Id = \(Constants.sharedInt.id)")
            // accessing the likeSave2 array with the selection id made on this cell.
            // likecount will be incremmented on each button click made on the like button on the "LikeGiverViewController" class file.
            self.likeSaver2[Constants.sharedInt.id].likecount += 1
            
            // saving the content
            PersistanceService.saveContext()
            // reload or refresh the table
            self.LikeTableView.reloadData()
            
        })
    }
    
    // if pressed the button call the "SearchViewController" class file
    @IBAction func ToSearchVC(_ sender: UIBarButtonItem) {
        //to SearchViewController
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
       let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
        
    }
    
   
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
   


}

//with extension I am going to call an addtional class "UITableViewDataSource" to the viewControler
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
        
        // onclick passes the id which is the cell no.
        vc.id = indexPath.row
        
        present(vc, animated: true, completion: nil)
    }
    
}

