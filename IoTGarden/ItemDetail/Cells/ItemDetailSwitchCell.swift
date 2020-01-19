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
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        didTapInfoAction?()
    }
    
    @IBOutlet weak var valueLabel: UILabel!
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
            valueLabel.text = value
        }
    }
    
    struct ViewModel: IdentifiableType, Equatable {
        var id = ""
        var name = ""
        var value = ""
        var message = ""
        
        typealias Identity = String
        var identity: String { return id }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            
            return lhs.id == rhs.id && lhs.name == rhs.name && lhs.value == rhs.value && lhs.message == rhs.message
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
