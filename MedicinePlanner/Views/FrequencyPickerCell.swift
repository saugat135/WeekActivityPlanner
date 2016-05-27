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

    override func awakeFromNib() {
        super.awakeFromNib()
        guard let picker = NSBundle.mainBundle().loadNibNamed(FrequencyPicker.nibName, owner: self, options: nil)[0] as? FrequencyPicker else { return }
        self.picker = picker
        self.picker.delegate = self
        self.picker.frequencyLabel.text = "\(self.frequency)"
        self.pickerPlaceHolder.addSubview(picker)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.picker.frame = self.pickerPlaceHolder.bounds
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
