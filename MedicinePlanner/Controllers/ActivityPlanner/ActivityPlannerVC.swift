import UIKit

let blue = UIColor(red: 29/255, green: 142/255, blue: 227/255, alpha: 1.0)
let red = UIColor(red: 255/255, green: 33/255, blue: 87/255, alpha: 1.0)

enum WeekDays: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    func stringValue() -> String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monvar"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }

    func shorthandStringValue() -> String {
        switch self {
        case .sunday: return "S"
        case .monday: return "M"
        case .tuesday: return "T"
        case .wednesday: return "W"
        case .thursday: return "T"
        case .friday: return "F"
        case .saturday: return "S"
        }
    }
}

class ActivityPlannerVC: UIViewController {
    
    @IBOutlet var weekSelectorView: UIView!
    
    private var activityPlannerTVC: ActivityPlannerTVC!
    private var weekViews: [ActivitySelectorView] = []
    private var selectedWeekView: ActivitySelectorView = ActivitySelectorView()
    private var currentDay: WeekDays = .sunday
    private var occurrenceInWeek = OccurrenceInWeek(count: 7, repeatedValue: OccurrenceInDay(activityTimes: []))
    
    // Model
    var activity: Activity!
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        if self.activity == nil {
            self.activity = Activity(activityName: "Default", activityType: .medicine)
        }
        super.init(coder: aDecoder)

    }
    var selectorView = WeekActivitySelectorView()
    // MARK: - Overriden VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        selectorView = UINib(nibName: "WeekActivitySelector", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! WeekActivitySelectorView
        selectorView.frame = weekSelectorView.bounds
        selectorView.delegate = self
        self.weekSelectorView.addSubview(selectorView)
    }
    
    override func viewDidLayoutSubviews() {
        selectorView.frame = weekSelectorView.bounds

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ActivityPlannerTVCSegueID" {
            guard let vc = segue.destinationViewController as? ActivityPlannerTVC else { return }
            self.activityPlannerTVC = vc
            self.activityPlannerTVC.delegate = self
            self.activityPlannerTVC.activityType = self.activity.activityType
        }
    }
    
    // MARK: - Actions

    @IBAction func done(sender: AnyObject) {
        //
    }
    
    func didTapView(view: ActivitySelectorView) {
        guard view != self.selectedWeekView else { return }
        resetAllWeekViews()
        self.currentDay = WeekDays(rawValue: self.selectorView.selectedSegment + 1)!
        view.titleLabel.backgroundColor = red
        view.titleLabel.textColor = UIColor.whiteColor()
        self.selectedWeekView = view
        self.activityPlannerTVC.activityTimes = self.activity.activityOccurrences[self.selectorView.selectedSegment].activityTimes
        self.activityPlannerTVC.currentFrequency = self.activityPlannerTVC.activityTimes.count
        self.activityPlannerTVC.tableView.reloadData()
    }
    
    // MARK: - Worker methods
    
    private func resetAllWeekViews() {
        var i = 0
        for view in self.weekViews {
            view.titleLabel.textColor = blue
            view.titleLabel.backgroundColor = UIColor.clearColor()
            if self.activity.activityOccurrences[i].frequency > 0 {
                view.activityImageView.image = self.activity.activityType.activityImageSelected()
            } else {
                view.activityImageView.image = self.activity.activityType.activityImageNormal()
            }
            i += 1
        }
    }
    
    private func resetActivityPlannerTVC() {
        self.activityPlannerTVC.reset()
    }
    
    private func updateActivity() {
        self.occurrenceInWeek[self.currentDay.rawValue - 1] = OccurrenceInDay(activityTimes: self.activityPlannerTVC.activityTimes)
        self.activity.activityOccurrences = self.occurrenceInWeek
    }

    private func loadActivitySelectorView() -> ActivitySelectorView {
        guard let view = UINib(nibName: "ActivitySelectorView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? ActivitySelectorView else { return ActivitySelectorView() }
        return view
    }

}

extension ActivityPlannerVC: WeekActivitySelectorViewDelegate {
    
    func didTap(view: ActivitySelectorView) {
        self.resetActivityPlannerTVC()
        self.didTapView(view)
    }
    
}

extension ActivityPlannerVC: ActivityPlannerTVCDelegate {
    
    func didIncreaseFrequency(frequency: Int) {
        let image = self.activity.activityType.activityImageSelected()
        self.selectorView.weekViews[self.selectorView.selectedSegment].activityImageView.image = image
        self.updateActivity()
    }

    func didDecreaseFrequency(frequency: Int) {
        var image = UIImage()
        if frequency == 0 {
            image = self.activity.activityType.activityImageNormal()
        } else {
            image = self.activity.activityType.activityImageSelected()
        }
        self.selectorView.weekViews[self.selectorView.selectedSegment].activityImageView.image = image
        self.updateActivity()
    }

    func didPickActivityTime(time: ActivityTime) {
        // TODO: - Handle the case when the time is picked from ActivityTimeTVC if required
    }
    
}
