//
//  ItemGaugeCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 3/1/20.
//

import UIKit
import GaugeKit
import Differentiator

class ItemGaugeCell: UITableViewCell {
    
    @IBOutlet private var valueGauge: Gauge!
    var didTapInfoAction: (() -> Void)?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    private weak var timer: Timer?
    
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        didTapInfoAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.text = ""
        
    }

    var viewModel: ViewModel? {
        didSet {
            nameLabel.text = viewModel?.name
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let weakSelf = self else { return }
                weakSelf.timeLabel.text = weakSelf.viewModel?.time.toDate()?.timeAgoDisplay()
            }
            
            
            let textValue = viewModel?.value ?? ""
            if textValue.containsNumbers() {
                let value = Float(viewModel?.value ?? "0") ?? Float(0)
                valueGauge.rate = CGFloat(value)
                valueLabel.text = textValue
            }

            layoutIfNeeded()

        }
    }
    
    struct ViewModel: IdentifiableType, Equatable  {
        var id = ""
        var name = ""
        var value = ""
        var time = ""
        
        
        typealias Identity = String
        var identity: String { return id }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            
            return lhs.id == rhs.id && lhs.name == rhs.name && lhs.value == rhs.value && lhs.time == rhs.time
        }
    }
    
}
