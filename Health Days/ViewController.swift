//
//  ViewController.swift
//  Health Days
//
//  Created by Cal on 10/12/14.
//  Copyright (c) 2014 Cal. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    let health = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(HKHealthStore.isHealthDataAvailable()){
            //health.requestAuthorizationToShareTypes(nil, readTypes: NSSet(array:[HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)]), completion: nil)
            //print(getPastQuantities(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierFlightsClimbed), numberOfDays: 6))
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getPastQuantities(type : HKQuantityType, numberOfDays: Int) -> Dictionary<NSDate, HKQuantity> {
        
        var calendar = NSCalendar.currentCalendar()
        var now = NSDate()
        var startDate = calendar.startOfDayForDate(now);
        var endDate = calendar.dateByAddingUnit(.DayCalendarUnit, value: 1, toDate: startDate, options: nil)
        
        var data : Dictionary<NSDate, HKQuantity> = [:]
        var done : Bool = false
        
        for(var day = 0; day > -(numberOfDays); day--){
            
            let final : Bool = (day == -(numberOfDays - 1))
            var rangeStart = calendar.dateByAddingUnit(.DayCalendarUnit, value: day, toDate: startDate, options: nil)
            var rangeEnd = calendar.dateByAddingUnit(.DayCalendarUnit, value: day + 1, toDate: startDate, options: nil)
            
            var predicate = HKQuery.predicateForSamplesWithStartDate(rangeStart, endDate: rangeEnd, options: nil)
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .CumulativeSum) { query, result, error in
                    data.updateValue(result.sumQuantity(), forKey: rangeStart!)
                    done = final
            }
            
            health.executeQuery(query)
        }
        
        while(!done){ }
        return data
        
    }
    

}

