//
//  FrequencyPickerCell.swift
//  MedicinePlanner
//
//  Created by Saugat Gautam on 5/24/16.
//  Copyright © 2016 Saugat Gautam. All rights reserved.
//

import UIKit

protocol FrequencyPickerCellDelegate {
    
    func didIncreaseFrequency()
    func didDecreaseFrequency()
    
}

class FrequencyPickerCell: UITableViewCell {
    
    var delegate: FrequencyPickerCellDelegate?
    
    @IBOutlet var pickerPlaceHolder: UIView!
    
    private var picker: FrequencyPicker!
    
    var frequency: Int = 0 {
        didSet {
            self.picker.frequencyLabel.text = "\(self.frequency)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialization code
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.picker = NSBundle.mainBundle().loadNibNamed(FrequencyPicker.nibName, owner: self, options: nil)[0] as! FrequencyPicker
        self.picker.delegate = self
        self.picker.frequencyLabel.text = "\(self.frequency)"
        self.pickerPlaceHolder.addSubview(picker)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.picker.frame = self.pickerPlaceHolder.bounds
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FrequencyPickerCell: FrequencyPickerDelegate {
    
    func didIncreaseFrequency() {
        self.delegate?.didIncreaseFrequency()
    }
    
    func didDecreaseFrequency() {
        self.delegate?.didDecreaseFrequency()
    }
    
}
