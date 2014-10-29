//
//  SettingsController.swift
//  Health Days
//
//  Created by Cal on 10/16/14.
//  Copyright (c) 2014 Cal. All rights reserved.
//

import UIKit
import HealthKit

class SettingsController: UIViewController {
    
    let health = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(HKHealthStore.isHealthDataAvailable()){
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stepsTest(sender: AnyObject) {
        health.requestAuthorizationToShareTypes(nil, readTypes: NSSet(array:[HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryZinc)]), completion: nil)
    }
    
    @IBAction func distanceTest(sender: AnyObject) {
        health.requestAuthorizationToShareTypes(nil, readTypes: NSSet(array:[HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)]), completion: nil)
    }
    
}