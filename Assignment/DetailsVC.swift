//
//  DetailsVC.swift
//  Assignment
//
//  Created by Asmita on 24/01/18.
//  Copyright © 2018 Asmita. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD
import KRActivityIndicatorView
class DetailsVC: UIViewController {

    var appDelegate = AppDelegate()
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var websiteLbl: UILabel!
    
    @IBOutlet var companyLbl: UILabel!
    var street : String?
    var suite : String?
    var city : String?
    var zipcode : String?
    var companyname : String?
    var catchphrase : String?
    var bs : String?
    var myContact : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        getAllData()
    }

    
 func getAllData(){
 if currentReachabilityStatus == .reachableViaWiFi || currentReachabilityStatus == .reachableViaWWAN
  {
    _ = KRProgressHUDAppearance()
    KRProgressHUD.show(withMessage: "Loading Contacts...")
    APIManagerClass().getContactDetailData(successHandler: { (responseData) in
          
    if let json = responseData as? [Any],  let response = json as? [[String:Any]]
    {
        for data in response
        {

         if data["phone"] as? String == self.myContact{
                        
                let name = data["name"] as! String? ?? ""
                let email = data["email"] as! String? ?? ""
                let username = data["username"] as! String? ?? ""
                        
                if let address = data["address"] as? NSDictionary {
                    self.street =  address["street"]  as! String? ?? ""
                    self.suite = address["suite"] as! String? ?? ""
                    self.city = address["city"] as! String? ?? ""
                    self.zipcode = address["zipcode"] as! String? ?? ""
                            
                }
                let website = data["website"] as! String? ?? ""
                        
                if let company = data["company"] as?  NSDictionary{
                            
                   self.companyname = company["name"] as! String? ?? ""
                   self.catchphrase = company["catchPhrase"] as! String? ?? ""
                   self.bs = company["bs"] as! String? ?? ""
                }
                        
                self.nameLbl.text = name
                self.usernameLbl.text = username
                self.emailLbl.text = email
                let add = "\(self.street!) , \(self.suite!) ,\(self.city!) , \(self.zipcode!)"
                self.addressLbl.text = add
                self.websiteLbl.text = website
                let comp = "\(self.companyname!) ,\(self.catchphrase!) , \(self.bs!)"
                self.companyLbl.text = comp
                      
              }
            
            }
        
        DispatchQueue.main.async(){
            KRProgressHUD.dismiss()
        }
        
        }
    }) { (error) in
   self.appDelegate.showAlertMessage(alertTitile: "Error..", alertMessage: error.localizedCapitalized)
    }
    }
    
    else {
     self.appDelegate.showAlertMessage(alertTitile: "Alert..", alertMessage: "Please check internet connection")
    }
    }
}
