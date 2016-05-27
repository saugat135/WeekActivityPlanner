//
//  Activity.swift
//  MedicinePlanner
//
//  Created by Saugat Gautam on 5/26/16.
//  Copyright © 2016 Saugat Gautam. All rights reserved.
//

import UIKit

enum ActivityType {
    case medicine
    case excercise
    
    func activityImageNormal() -> UIImage {
        switch self {
        case .medicine:
            return UIImage(named: "Medicine-normal")!
        case .excercise:
            return UIImage(named: "BreathingExcercise-normal")!
        }
    }
    
    func activityImageSelected() -> UIImage {
        switch self {
        case .medicine:
            return UIImage(named: "Medicine-selected")!
        case .excercise:
            return UIImage(named: "BreathingExcercise-normal")!
        }
    }
}

typealias OccurrenceInWeek = Array<OccurrenceInDay>

class Activity {
    
    let activityType: ActivityType
    let activityName: String
    
        /// Array of occurrences in each day of the week. Index 0 corresponds to Occurrences in Sunday and so on.
    var activityOccurrences: OccurrenceInWeek
    
    init(activityName: String, activityType: ActivityType) {
        self.activityName = activityName
        self.activityType = activityType
        self.activityOccurrences = OccurrenceInWeek(count: 7, repeatedValue: OccurrenceInDay(activityTimes: []))
    }

}

struct OccurrenceInDay {
    var frequency: Int {
        get {
            return self.activityTimes.count
        }
    }
    var activityTimes: [ActivityTime]
}
