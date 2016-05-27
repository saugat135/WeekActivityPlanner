//
//  WeekActivitySelectorView.swift
//  MedicinePlanner
//
//  Created by Saugat Gautam on 5/27/16.
//  Copyright © 2016 Saugat Gautam. All rights reserved.
//

import UIKit

protocol WeekActivitySelectorViewDelegate {
    func didTap(view: ActivitySelectorView)
}

class WeekActivitySelectorView: UIView {
    
    var delegate: WeekActivitySelectorViewDelegate?
    
    @IBOutlet var weekSelectorStkView: UIStackView!
    
    var activeBackgroundColor = red
    var inactiveBackgroundColor = UIColor.clearColor()
    
    var activeTitleColor = UIColor.whiteColor()
    var inactiveTitleColor = blue
    
    var activityImage = UIImage()
    
    var weekViews: [ActivitySelectorView] = Array<ActivitySelectorView>(count: 7, repeatedValue: ActivitySelectorView())
    
    var selectedSegment = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 1...7 {
            let view = loadActivitySelectorView()
            
            view.activityImageView.image = ActivityType.medicine.activityImageNormal() //activityImage
            view.activityImageView.contentMode = .ScaleAspectFit

            view.titleLabel.text = WeekDays(rawValue: i)!.shorthandStringValue()
            
            view.delegate = self
            
            self.weekViews[i - 1] = view
            self.weekSelectorStkView.addArrangedSubview(view)
            
            self.weekSelectorStkView.alignment = .Fill
            self.weekSelectorStkView.distribution = .FillEqually
        }
    }
    
    private func loadActivitySelectorView() -> ActivitySelectorView {
        guard let view = UINib(nibName: "ActivitySelectorView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? ActivitySelectorView else { return ActivitySelectorView() }
        return view
    }
    
    private func resetAllWeekViews() {
        for view in self.weekViews {
            self.makeInactive(view)
        }
    }
    
    func makeActive(view: ActivitySelectorView) {
        view.titleLabel.backgroundColor = self.activeBackgroundColor
        view.titleLabel.textColor = self.activeTitleColor
    }
    
    func makeInactive(view: ActivitySelectorView) {
        view.titleLabel.backgroundColor = self.inactiveBackgroundColor
        view.titleLabel.textColor = self.inactiveTitleColor
    }

}

extension WeekActivitySelectorView: ActivitySelectorViewDelegate {
    
    func didTap(view: ActivitySelectorView) {
        self.resetAllWeekViews()
        self.makeActive(view)
        self.selectedSegment = self.weekViews.indexOf(view)!
        print(selectedSegment)
        self.delegate?.didTap(view)
    }
    
}
