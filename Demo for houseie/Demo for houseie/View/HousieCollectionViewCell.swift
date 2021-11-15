//
//  HousieCollectionViewCell.swift
//  Demo for houseie
//
//  Created by Mohan on 04/01/21.
//  Copyright © 2021 Mohan. All rights reserved.
//

import UIKit

class HousieCollectionViewCell: UICollectionViewCell {
    private var labelSize : CGFloat = 0.0
    private var fsize : Int = 0
	
    let label : UILabel = {
        let p = UILabel()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.adjustsFontSizeToFitWidth = true
		p.textColor = .white
        p.font = UIFont(name: "Helvetica", size: 10)
        return p
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        contentView.addSubview(label)

		self.layer.borderColor = UIColor.blue.cgColor
		self.layer.borderWidth = 2
        label.font = UIFont.boldSystemFont(ofSize: returnSize())
        updateCons()
    }
    
    func updateCons() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func returnSize() -> CGFloat {
    switch(traitCollection.preferredContentSizeCategory) {
        case UIContentSizeCategory.extraSmall:
            fallthrough
        case UIContentSizeCategory.small:
            fallthrough
        case UIContentSizeCategory.medium:
            fallthrough
        case UIContentSizeCategory.large:
            fallthrough
        case UIContentSizeCategory.extraLarge:
            fallthrough
        case UIContentSizeCategory.extraExtraLarge:
            fallthrough
        case UIContentSizeCategory.extraExtraExtraLarge:
            return 26
        case UIContentSizeCategory.accessibilityMedium:
            fallthrough
        case UIContentSizeCategory.accessibilityLarge:
            fallthrough
        case UIContentSizeCategory.accessibilityExtraLarge:
            fallthrough
        case UIContentSizeCategory.accessibilityExtraExtraLarge:
            fallthrough
        case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
            return 30
        default:
            return 36
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        label.font = UIFont.boldSystemFont(ofSize: CGFloat(returnSize()))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func correctFontSize() {
        print("ENTERING CORRECTFONTDIZE")
        var constraintSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        var fSize = 36
        repeat {
            var f = UIFont.init(name: label.font.fontName, size: CGFloat(fSize))
        var text = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            var lp = label.text as! NSString
           var pp = lp.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : f], context: nil)
            var newlabelSize = pp.size
            print(newlabelSize.width,newlabelSize.height," newlabelsize")
            if (ceilf(Float(newlabelSize.height)) <= ceilf(Float(self.bounds.height))) && (ceilf(Float(newlabelSize.width)) <= ceilf(Float(self.bounds.width))) {
                break
            }
            fSize -= 1
        } while (fSize > 28)
    print("SIZE FONT ",fSize)
    }
    
}
