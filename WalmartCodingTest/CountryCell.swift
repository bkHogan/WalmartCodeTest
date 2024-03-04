//
//  CountryCell.swift
//  WalmartCodingTest
//
//  Created by Brian Hogan on 3/3/24.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var regionCodeLabel: UILabel!
    
    @IBOutlet weak var capitalLabel: UILabel!
    
    func configure(with country: Country) {
        namelabel.text = "\(country.name), \(country.region)"
        regionCodeLabel.text = country.code
        capitalLabel.text = country.capital
    }
}
