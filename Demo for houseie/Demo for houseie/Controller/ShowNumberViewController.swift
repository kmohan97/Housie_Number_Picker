//
//  ShowNumberViewController.swift
//  Demo for houseie
//
//  Created by Mohan on 21/01/21.
//  Copyright © 2021 Mohan. All rights reserved.
//

import UIKit

class ShowNumberViewController: UIViewController {

	var number : String? {
		didSet {
			self.numberLabel.text = number
		}
	}
	
	
    lazy var numberLabel : UILabel = {
        var p = UILabel()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.numberOfLines = 0
        p.adjustsFontSizeToFitWidth = true
		p.textAlignment = .center
		p.textColor = .white
		p.adjustsFontForContentSizeCategory = true
        p.font = UIFont.boldSystemFont(ofSize: 100)
        return p
    }()
	
	let labelView : UIView = {
		let p = UIView()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.layer.borderWidth = 4
		p.layer.borderColor = UIColor.blue.cgColor
		return p
	}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//		view.layer.opacity = .init(0.5)
		view.addSubview(labelView)
		labelView.addSubview(numberLabel)
//		view.backgroundColor = .lightGray
		
		
		labelView.layer.cornerRadius = 24
		labelView.layer.opacity = 1
		
		view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(removeMe)))
		view.isUserInteractionEnabled = true
		
		labelView.layer.masksToBounds = true
		
        
		labelView.backgroundColor = .purple
        updateConstraints()
        if(number != "") {
            numberLabel.text = number
        }
    }
    
    func updateConstraints() {
		
		var p = super.view.frame.width
		print(p)
		print("updateCons")
        NSLayoutConstraint.activate([
			
//			labelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			labelView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75),
			labelView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			labelView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
			labelView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
			
			
			numberLabel.topAnchor.constraint(equalTo: self.labelView.topAnchor),
			numberLabel.leadingAnchor.constraint(equalTo: self.labelView.leadingAnchor),
			numberLabel.trailingAnchor.constraint(equalTo: self.labelView.trailingAnchor),
			numberLabel.bottomAnchor.constraint(equalTo: self.labelView.bottomAnchor)

        ])
    }
  //works only for view controller
	
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.dismiss(animated: true, completion: nil)
//
//    }
	
	@objc func removeMe() {
		print("in the removeME")
		self.view.removeFromSuperview()
	}
}
