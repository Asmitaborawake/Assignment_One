//
//  ViewController.swift
//  Assignment
//
//  Created by Asmita on 24/01/18.
//  Copyright © 2018 Asmita. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD
import KRActivityIndicatorView

class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    @IBOutlet var tableview: UITableView!
    var appDelegate = AppDelegate()
    var Datadict = NSMutableDictionary()
    var mainarray = NSMutableArray()
    var selectedContact: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dataCall()
    }

    func dataCall(){
     if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN {
        
        _ = KRProgressHUDAppearance()
        KRProgressHUD.show(withMessage: "Loading Contacts...")
        APIManagerClass().getContactDetailData(successHandler: { (responseData) in
        print(responseData)
            
        if let json = responseData as? [Any],  let response = json as? [[String:Any]]
           {
            for data in response {
                print(data["phone"] as? String ?? "")
                
                let phone = data["phone"] as? String ?? ""
                
                self.Datadict = NSMutableDictionary()
                self.Datadict.setValue(phone, forKey: "phone")
                
                self.mainarray.add(self.Datadict)
               self.tableview.reloadData()
                
            }
            }
            
            DispatchQueue.main.async(){
                KRProgressHUD.dismiss()
            }
        }) { (error) in
            
            self.appDelegate.showAlertMessage(alertTitile: "Error..", alertMessage: error.localizedCapitalized)
    
            }
        }
     else {
        
        self.appDelegate.showAlertMessage(alertTitile: "Alert..", alertMessage: "Please check internet connection")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
       
        let datadict = mainarray[indexPath.row] as? NSDictionary
        cell.textLabel?.text = datadict?.value(forKey: "phone") as? String
        return cell
    }
    
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            
            let destViewController = segue.destination as! DetailsVC
            let indexPath = tableview.indexPathForSelectedRow!
            let currentCell = tableview.cellForRow(at: indexPath)! as UITableViewCell
            selectedContact = currentCell.textLabel?.text
            destViewController.myContact = selectedContact
            
            
        }     
    }
    

}

