//
//  SettingViewController.swift
//  SettingViewController
//
//  Created by Mohan on 01/11/21.
//  Copyright © 2021 Mohan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

	let label: UILabel = {
		let p = UILabel()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.text = "Settings"
		p.textAlignment = .center
		p.textColor = .black
		p.font = UIFont.boldSystemFont(ofSize: 30)
		return p
	}()
	
	var defaultTime: String? {
		didSet {
			timerSegment.isOn = true
			timerField.isHidden = false
			timerField.text = defaultTime
		}
	}
	
	var delegate : SettingsData?
	
	let audioLabel: UILabel = {
		let p = UILabel()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.text = "Set Audio"
		p.textColor = .black
		p.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
		return p
	}()
	
	let timerLabel: UILabel = {
		let p = UILabel()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.text = "Set Timer"
		p.textColor = .black
		p.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
		return p
	}()
	
	let audioSegment: UISwitch = {
		let p = UISwitch()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.isOn = true
		p.isSelected = true
		return p
	}()
	
	let timerSegment: UISwitch = {
		let p = UISwitch()
		p.addTarget(self, action: #selector(setTimer(_ :)), for: .valueChanged)
		p.translatesAutoresizingMaskIntoConstraints = false
		return p
	}()
	
	let setButton: UIButton = {
		let p = UIButton(type: .custom)
		p.translatesAutoresizingMaskIntoConstraints = false
		p.backgroundColor = .blue
		p.setTitle("Set", for: .normal)
		p.isUserInteractionEnabled = true
		p.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
		return p
	}()
	
	let containerView: UIView = {
		let p = UIView()
		p.backgroundColor = .yellow
		p.translatesAutoresizingMaskIntoConstraints = false
		return p
	}()
	
	let timerField: BottomLineTextField = {
		let p = BottomLineTextField()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.enablesReturnKeyAutomatically = true
		p.isHidden = true
		p.textColor = .black
		p.text = String(4)
		return p
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .clear
		view.addSubview(containerView)
		containerView.addSubview(label)
		containerView.addSubview(audioLabel)
		containerView.addSubview(audioSegment)
		containerView.addSubview(timerLabel)
		containerView.addSubview(timerSegment)
		containerView.addSubview(setButton)
		containerView.addSubview(timerField)
		addConstraint()
    }
    
	func addConstraint() {
		NSLayoutConstraint.activate([
			containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
			containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
			
			label.topAnchor.constraint(equalTo: containerView.topAnchor),
			label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			
			audioLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 15),
			audioLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
			
			audioSegment.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 15),
			audioSegment.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
			
			timerLabel.topAnchor.constraint(equalTo: audioLabel.bottomAnchor, constant: 15),
			timerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
			
			timerSegment.topAnchor.constraint(equalTo: audioSegment.bottomAnchor, constant: 15),
			timerSegment.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
			
			timerLabel.lastBaselineAnchor.constraint(equalTo: timerSegment.bottomAnchor,constant: -5),
			audioLabel.lastBaselineAnchor.constraint(equalTo: audioSegment.bottomAnchor,constant: -5),
			
//			timerField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//			timerField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			timerField.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 15),
			timerField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			timerField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
			
			setButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			setButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			setButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
			
		])
	}
	
	@objc func setButtonTapped() {
		var dict : [String : Any]  = [
			"audio": audioSegment.isOn,
			"timer": timerSegment.isOn,
			"time": timerField.text
		]
		delegate?.sendSettingsData(dict)
		self.dismiss(animated: true, completion: nil)
	}
	
//	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//		self.dismiss(animated: true, completion: nil)
//	}
	
	@objc func setTimer(_ sender: UISwitch) {
		if timerSegment.isOn {
			timerField.isHidden = false
		} else {
			timerField.isHidden = true
		}
	}
}
