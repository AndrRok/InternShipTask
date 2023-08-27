//
//  MainLabel.swift
//  InternShipTask
//
//  Created by ARMBP on 8/26/23.
//

import UIKit

final class MainLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, weight: UIFont.Weight){
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = .systemFont(ofSize: fontSize, weight: weight)
    }
    
    private func configure(){
        textColor                                   = .label
        adjustsFontSizeToFitWidth                   = true
        lineBreakMode                               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints   = false
        numberOfLines                               = 0
        adjustsFontSizeToFitWidth                   = false
    }
}
