//
//  DatabaseQuery.swift
//  LocationMessenger
//
//  Created by Mark Pizzutillo on 5/19/18.
//  Copyright © 2018 Mark Pizzutillo, Bayley Hart. All rights reserved.
//

import Foundation
import Firebase

class DatabaseQuery {
    enum requestType: String {
        case places
        func toString()->String {
            return self.rawValue
        }
    }
    
    //Database reference
    static let ref = Database.database().reference()
    
    //Snapshot from database
    static var snapshot: DataSnapshot? = nil
    
    //-------------------------------------------------------------
    // Function: getFromDB()
    // Returns a DataSnapshot of the specified sub-table in the DB
    // First, updates the static snapshot variable, and returns
    //-------------------------------------------------------------
    static func getFromDB(type: requestType) -> DataSnapshot? {
        self.ref.child(type.toString()).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.snapshot = snapshot
        }) { (error) in
            //Handle errors here
        }
        return self.snapshot
    }
}
