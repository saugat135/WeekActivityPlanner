//
//  MainVCViewController.swift
//  MedicinePlanner
//
//  Created by Saugat Gautam on 5/27/16.
//  Copyright © 2016 Saugat Gautam. All rights reserved.
//

import UIKit

class MainVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let activityPlannerVC = sb.instantiateViewControllerWithIdentifier("ActivityPlannerVCID") as! ActivityPlannerVC
        let activity = Activity(activityName: "Medicine", activityType: .medicine)
        activity.activityOccurrences = OccurrenceInWeek(count: 7, repeatedValue: OccurrenceInDay(activityTimes: [.earlyMorning]))
        activityPlannerVC.activity = activity
        self.presentViewController(activityPlannerVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
