//
//  APIManagerClass.swift
//  Assignment
//
//  Created by Asmita on 24/01/18.
//  Copyright © 2018 Asmita. All rights reserved.
//

import Foundation
import Alamofire

class APIManagerClass: NSObject {
    
    var manager : SessionManager?
    
    override init()
    {
        manager = Alamofire.SessionManager.default
        manager?.session.configuration.timeoutIntervalForRequest = 20
    }
    func getContactDetailData(successHandler: @escaping (NSArray) -> Void,failureHandler: @escaping (String) -> Void)
    {
        
        
        let urlRequest:String = BaseUrl.CallURL
        let headerhead:Dictionary<String, String> = ["Content-Type":"application/json"]
       
        
        manager?.request(urlRequest, method: .get, encoding: JSONEncoding.default, headers: headerhead).validate().validate().responseJSON
            { response in
                
                if response.result.isSuccess
                {
                    let resJson = response.result.value!
                    successHandler(resJson as! NSArray)
                }
                if response.result.isFailure
                {
                    let error : Error = response.result.error!
                    failureHandler(error.localizedDescription)
                    
                }
        }
        
    }
    
    
}
