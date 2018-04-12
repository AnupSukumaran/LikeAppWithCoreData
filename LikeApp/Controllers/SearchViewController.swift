//
//  SearchViewController.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 12/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchTable: UITableView!
    
    @IBOutlet weak var SearchField: UITextField!
    

    var providersAPI = APIService()
    
    var searchDetails = [SearchDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SearchField.delegate = self
        SearchField.clearButtonMode = .whileEditing
        
        SearchField.allowsEditingTextAttributes = true
        SearchField.autocorrectionType = UITextAutocorrectionType.no
        

        
        calllingURl()
    }
    
    @IBAction func TextChanged(_ sender: UITextField) {
        
        providersAPI.keyWords.removeAll()
        searchDetails.removeAll()
        searchTable.reloadData()
        
        let key: AnyObject = SearchField.text as AnyObject
        
        print("Key = \(key)")
        
        providersAPI.keyWords = key as! String
        
        calllingURl()
    }

    
    
    func calllingURl() {
        
        
        
        providersAPI.searchApi { (values) in
            switch values {
            case .Success(let data):
                
                print("DDDD123 = \(data)")
                
               // self.jsonResultParse(data as AnyObject)
            case .Error(let message):
                print("Error = \(message)")
            }
        }
        
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension SearchViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableTableViewCell", for: indexPath) as! SearchTableTableViewCell
        
        return cell
    }
    
    
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchField.resignFirstResponder()
        
        return true
    }
    
}


