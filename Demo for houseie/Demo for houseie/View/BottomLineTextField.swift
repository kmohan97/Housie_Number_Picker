//
//  BottomLineTextField.swift
//  BottomLineTextField
//
//  Created by Mohan on 02/11/21.
//  Copyright © 2021 Mohan. All rights reserved.
//

import UIKit

class BottomLineTextField: UITextField {
	
	let bottomLine = UIView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.borderStyle = .none
		
		bottomLine.translatesAutoresizingMaskIntoConstraints = false
		bottomLine.backgroundColor = .red
		self.addSubview(bottomLine)
		
		NSLayoutConstraint.activate([
			bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor),
			bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			bottomLine.heightAnchor.constraint(equalToConstant: 1)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
