//
//  ActivitySelectorView.swift
//  MedicinePlanner
//
//  Created by Saugat Gautam on 5/25/16.
//  Copyright © 2016 Saugat Gautam. All rights reserved.
//

import UIKit

protocol ActivitySelectorViewDelegate {
    func didTap(view: ActivitySelectorView)
}

class ActivitySelectorView: UIView {
    
    var delegate: ActivitySelectorViewDelegate?
    
    @IBOutlet var activityImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc private func didTapView(gestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.didTap(self)
    }
}
