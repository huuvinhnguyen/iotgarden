//
//  ItemDetailSwitchCell.swift
//  IoTGarden
//
//  Created by Vinh Nguyen on 9/5/19.
//

import UIKit
import Differentiator

class ItemDetailSwitchCell: UITableViewCell {
    
    var didTapInfoAction: (() -> Void)?
    var didTapSwitchAction: ((String) -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var bulbImageView: UIImageView!
    
    private weak var timer: Timer?
    
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        didTapInfoAction?()
    }
    
    @IBAction private func switchButtonTapped(_ sender: UIButton) {
        
        let dict = convertToDictionary(text: viewModel?.message ?? "")
        let msgOff = dict?["off"] as? String ?? ""
        let msgOn = dict?["on"] as? String ?? ""
        
        var publishedMessage = msgOn
        
        let value = viewModel?.value ?? ""
        
        if value == msgOn && !value.isEmpty {
            publishedMessage = msgOff
        }
        
        if value == msgOff && !value.isEmpty {
            publishedMessage = msgOn
        } 
        
       
        didTapSwitchAction?(publishedMessage)
    }
    
    
    var viewModel: ViewModel? {
        didSet {
            let value = viewModel?.value ?? ""
            nameLabel.text = viewModel?.name
            timeLabel.text = ""
            valueLabel.text = value
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard let weakSelf = self else { return }
                weakSelf.timeLabel.text = weakSelf.viewModel?.time.toDate()?.timeAgoDisplay()

            }
            
            let dict = convertToDictionary(text: viewModel?.message ?? "")
            let msgOff = dict?["off"] as? String ?? ""
            let msgOn = dict?["on"] as? String ?? ""
            
            if msgOn == viewModel?.value {
                bulbImageView.isHighlighted = true
            } else if msgOff == viewModel?.value {
                bulbImageView.isHighlighted = false
            }

        }
    }
    
    struct ViewModel: IdentifiableType, Equatable {
        var id = ""
        var name = ""
        var value = ""
        var message = ""
        var time = ""
        
        typealias Identity = String
        var identity: String { return id }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            
            return lhs.id == rhs.id && lhs.name == rhs.name && lhs.value == rhs.value && lhs.message == rhs.message && lhs.time == rhs.time
        }

    }
    
    private func configure() {
        
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
