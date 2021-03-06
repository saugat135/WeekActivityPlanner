
import UIKit

protocol ActivityPlannerTVCDelegate {
    func didIncreaseFrequency(frequency: Int)
    func didDecreaseFrequency(frequency: Int)
    func didPickActivityTime(time: ActivityTime)
}

class ActivityPlannerTVC: UITableViewController {
    
    private enum Section: Int {
//        case firstDosage = 0
        case frequency = 0
        case summary
        
        func headerView(activityType: ActivityType, frame: CGRect) -> UIView {
            
            let headerLabel = UILabel(frame: frame)
            headerLabel.text = self.headerText(activityType)
            headerLabel.font = UIFont.systemFontOfSize(15)
            headerLabel.textColor = UIColor(red: 109/255, green: 109/255, blue: 114/255, alpha: 1.0)
            headerLabel.sizeToFit()
            
            let view = UIView(frame: frame)
            view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
            headerLabel.frame.origin.y = (frame.size.height - 15) / 2
            headerLabel.frame.origin.x = 16
            view.addSubview(headerLabel)
//            view.backgroundColor = UIColor.blackColor()
            
            return view
        }
        
        func headerText(activityType: ActivityType = .medicine) -> String {
            var frequencyHeaderText = ""
            var summaryHeaderText = ""
            
            switch activityType {
            case .excercise:
                frequencyHeaderText = "Set the frequency of excercise."
                summaryHeaderText = "Your excercise summary for this day."
            case .medicine:
                frequencyHeaderText = "Set the frequency you will be having your medication."
                summaryHeaderText = "Your medication summary for this day."
            }
            switch self {
//            case .firstDosage:
//                return "Set your first dosage time"
            case .frequency:
                return frequencyHeaderText
            case .summary:
                return summaryHeaderText
            }
        }
    }
    
    var delegate: ActivityPlannerTVCDelegate?
    
    private var sections: [Section] = [/*.firstDosage,*/ .frequency, .summary]
//    private var firstDosage: ActivityTime = ActivityTime.morning
    var activityTimes: [ActivityTime] = []
    var activityType: ActivityType = .medicine
    var currentFrequency: Int!
    
    var minFrequency: Int!
    var maxFrequency: Int!
    
    private var activityTimesTVC: ActivityTimeTVC!
    
    private var selectedIndexPath: NSIndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
//        self.activityTimes = [firstDosage]
        self.currentFrequency = self.activityTimes.count

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sectionEnum = Section(rawValue: section) else {
            return 0
        }
        switch sectionEnum {
        //case .firstDosage:
          //  return 1
        case .frequency:
            return 1
        case .summary:
            return self.activityTimes.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell(frame: CGRectZero)
        }
        switch section {
        //case .firstDosage:
          //  return self.configureFirstDosageSection()
        case .frequency:
            return self.configureFrequencySection()
        case .summary:
            return self.configureSummarySection(indexPath.row)
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionEnum = Section(rawValue: section) else {
            return nil
        }
        
        var frame = CGRectZero
        frame.size = CGSize(width: (self.tableView.frame.width - CGFloat(16)), height: 50)
        return sectionEnum.headerView(self.activityType, frame: frame)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        switch section {
        //case .firstDosage:
          //  self.segueToActivityTimeTVC()
            //break
        case .frequency:
            break
        case .summary:
            self.selectedIndexPath = indexPath
            self.segueToActivityTimeTVC()
            break
        }
    }
    
    func reset() {
        self.currentFrequency = 0
        self.activityTimes = []
        self.tableView.reloadData()
    }
    /*
    private func configureFirstDosageSection() -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TimeIntervalCellID")
        cell?.textLabel?.text = firstDosage.stringValue()
        cell?.detailTextLabel?.text = firstDosage.timeIntervalString()
        return cell!
    }
 */
    
    private func configureFrequencySection() -> FrequencyPickerCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("FrequencyCellID") as! FrequencyPickerCell
        cell.delegate = self
        cell.frequency = self.currentFrequency
//        cell?.textLabel?.text = "Position"
    
        return cell
    }
    
    private func configureSummarySection(row: Int) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TimeIntervalCellID")
        cell?.textLabel?.text = self.activityTimes[row].stringValue()
        cell?.detailTextLabel?.text = self.activityTimes[row].timeIntervalString()
        return cell!
    }
    
    private func segueToActivityTimeTVC() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.activityTimesTVC = sb.instantiateViewControllerWithIdentifier("ActivityTimeTVCID") as! ActivityTimeTVC
        self.activityTimesTVC.delegate = self
        for activityTime in activityTimesTVC.activityTimes {
            if self.activityTimes.contains(activityTime) {
                activityTimesTVC.activityTimes.removeAtIndex(activityTimesTVC.activityTimes.indexOf(activityTime)!)
            }
        }
        self.navigationController?.pushViewController(activityTimesTVC, animated: true)
    }
    
    private func activityTimesAccordingToFrequency(frequency: Int) -> [ActivityTime] {
        // Start with morning time
        // Divide the default activity times with the current frequency.
        // Map the activity times
        // Return
        guard frequency > 0 else { return [] }
        let totalActivityTime = ActivityTime.allActivityTimes().count + 1
        var activityTimes: [ActivityTime] = []
        let interval = totalActivityTime / frequency
        var currentInterval: Int = 0

        for i in 1...frequency {
            if currentInterval > 10 {
                currentInterval = 10
            } else if currentInterval < 0 {
                currentInterval = 0
            }
            activityTimes.append(ActivityTime.allActivityTimes()[currentInterval])
            print(currentInterval)
            currentInterval = interval + currentInterval
        }
        return activityTimes
    }
    

}

extension ActivityPlannerTVC: FrequencyPickerCellDelegate {
    
    func didIncreaseFrequency() {
        guard self.currentFrequency < 11 else { return }
        self.currentFrequency = self.currentFrequency + 1
        
        self.activityTimes = activityTimesAccordingToFrequency(self.currentFrequency)
        
        let lastIndex = ActivityTime.allActivityTimes().indexOf(self.activityTimes.last!)
        
//        if lastIndex < ActivityTime.allActivityTimes().count - 1 {
//            self.activityTimes.append(ActivityTime.allActivityTimes()[lastIndex! + 1])
//        } else {
//            self.activityTimes.append(ActivityTime.allActivityTimes()[0])
//        }
        self.activityTimes.sortInPlace { (time1, time2) -> Bool in
            time1.sortIndex() < time2.sortIndex()
        }
        self.tableView.reloadData()
        self.delegate?.didIncreaseFrequency(self.currentFrequency)
    }
    
    func didDecreaseFrequency() {
        guard self.currentFrequency > 0 else { return }
        self.currentFrequency = self.currentFrequency - 1
        self.activityTimes = activityTimesAccordingToFrequency(self.currentFrequency)

//        self.activityTimes.removeLast()
        self.tableView.reloadData()
        self.delegate?.didDecreaseFrequency(self.currentFrequency)
    }
    
}

extension ActivityPlannerTVC: ActivityTimeTVCDelegate {
    
    func didPickActivityTime(time: ActivityTime) {
        
        self.activityTimes[selectedIndexPath.row] = time
        self.activityTimes.sortInPlace { (time1, time2) -> Bool in
            time1.sortIndex() < time2.sortIndex()
        }
        self.currentFrequency = self.activityTimes.count
//        self.firstDosage = self.activityTimes[0]
        
    }
}
