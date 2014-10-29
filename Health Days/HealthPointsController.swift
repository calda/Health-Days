//
//  ViewController.swift
//  Health Days
//
//  Created by Cal on 10/12/14.
//  Copyright (c) 2014 Cal. All rights reserved.
//

import UIKit
import HealthKit

class HealthPointsController: UIViewController {

    let health = HKHealthStore()
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scroll.scrollEnabled = true
        //scroll.contentSize = CGSizeMake(view.bounds.size.width, 1000)
        // Do any additional setup after loading the view, typically from a nib.
        updateContent(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateContent(sender: AnyObject?) {
        if(HKHealthStore.isHealthDataAvailable()){
            health.requestAuthorizationToShareTypes(nil, readTypes: NSSet(array:[HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)]), completion: nil)
            var data = getPastQuantities(HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount), numberOfDays: 20)
            var days = Array(data.keys)
            sort(&days, { (day1 : NSDate, day2 : NSDate) -> Bool in
                return day1.timeIntervalSince1970 > day2.timeIntervalSince1970
            })
            var forTextView = ""
            for day in days{
                var date = "\(day)".componentsSeparatedByString(" ")[0]
                forTextView += "\(date):\t\(data[day]!)\n"
            }
            textView.text = forTextView
            
        }
    }
    
    func getPastQuantities(type : HKQuantityType, numberOfDays: Int) -> Dictionary<NSDate, HKQuantity> {
        
        var calendar = NSCalendar.currentCalendar()
        var now = NSDate()
        var startDate = calendar.startOfDayForDate(now);
        var endDate = calendar.dateByAddingUnit(.DayCalendarUnit, value: 1, toDate: startDate, options: nil)
        
        var data : Dictionary<NSDate, HKQuantity> = [:]
        var countDone = 0
        
        for(var day = 0; day > -(numberOfDays); day--){
            
            let final : Bool = (day == -(numberOfDays - 1))
            var rangeStart = calendar.dateByAddingUnit(.DayCalendarUnit, value: day, toDate: startDate, options: nil)
            var rangeEnd = calendar.dateByAddingUnit(.DayCalendarUnit, value: day + 1, toDate: startDate, options: nil)
            
            var predicate = HKQuery.predicateForSamplesWithStartDate(rangeStart, endDate: rangeEnd, options: nil)
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .CumulativeSum) { query, result, error in
                if let value = result{
                    data.updateValue(value.sumQuantity(), forKey: rangeStart!)
                }
                countDone++
            }
            
            health.executeQuery(query)
        }
        
        while(countDone < numberOfDays){ }
        return data
        
    }
    

}

