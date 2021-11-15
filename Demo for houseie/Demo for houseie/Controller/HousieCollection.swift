//
//  HousieCollection.swift
//  Demo for houseie
//
//  Created by Mohan on 04/01/21.
//  Copyright © 2021 Mohan. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "Cell"

protocol SettingsData : NSObjectProtocol {
	func sendSettingsData(_ data: [String : Any])
}

class HousieCollection: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate ,UICollectionViewDelegateFlowLayout {
	
	static var numbersArray : [String] = []
	private var landscape : [NSLayoutConstraint] = []
	
	var buttonState: Bool = false
	//false -> play
	//true -> pause
	var timerForRemovingNumber: Timer?
	
	var timeSetInSettings: Int?
	var shouldSpeak: Bool = true
	var lock = NSLock()
	lazy var uv1 : UIView = {
		let p = UIView()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.backgroundColor = UIColor.clear
		return p
	}()
	
	var shNumObj: ShowNumberViewController?
	
	let uv2 : UIView = {
		let p = UIView()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.backgroundColor = UIColor.clear
		return p
	}()
	
	let uv3 : UIView = {
		let p = UIView()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.backgroundColor = UIColor.clear
		return p
	}()
	
	let uv4 : UIView = {
		let p = UIView()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.backgroundColor = UIColor.lightText
		return p
	}()
	
	let titleLabel: UILabel = {
		let p = UILabel()
		p.translatesAutoresizingMaskIntoConstraints = false
		p.text = "Housie Number Picker"
		p.textColor = .black
		p.font = UIFont.boldSystemFont(ofSize: 20)
		return p
	}()
	
	var currentIndexToShow: Int?
	
	let playButton : UIButton = {
		let p = UIButton(type: .custom)
		p.translatesAutoresizingMaskIntoConstraints = false
		p.backgroundColor = .clear
		p.layer.cornerRadius = 24
		//play.circle
		let imageConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40), scale: .large)
		var myImage = UIImage(systemName: "play.circle", withConfiguration: imageConfig)
		p.setImage(myImage, for: .normal)
		p.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
		return p
	}()
	
	let resetButton : UIButton = {
		let p = UIButton(type: .custom)
		p.translatesAutoresizingMaskIntoConstraints = false
		let imageConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30), scale: .large)
		var myImage = UIImage(systemName: "goforward", withConfiguration: imageConfig)
		
		p.setImage(myImage, for: .normal)
		p.addTarget(self, action: #selector(resetAlert), for: .touchUpInside)
		return p
	}()
	
	let settingButton : UIButton = {
		let p = UIButton(type: .custom)
		p.translatesAutoresizingMaskIntoConstraints = false
		var image = UIImage(named: "setting3")?.withRenderingMode(.alwaysTemplate)
		p.backgroundColor = .clear
		p.setImage(image, for: .normal)
		p.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
		return p
	}()
	
	@objc func resetAlert() {
		var alCont = UIAlertController(title: "Reset", message: "Please confirm if you want to reset ?", preferredStyle: .alert)
		var yesButton = UIAlertAction(title: "Yes", style: .default) { [weak self]_ in
			self?.resetData()
		}
		var cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alCont.addAction(yesButton)
		alCont.addAction(cancelButton)
		present(alCont, animated: true, completion: nil)
	}
	
	@objc func resetData(completingAllItem: Bool = false) {
		guard let obj = shNumObj else {
			print("Could not find the number view")
			return
		}
		timerForRemovingNumber?.invalidate()
		timerForRemovingNumber = nil
		obj.view.removeFromSuperview()
		prevButton.isEnabled = false
		nextButton.isEnabled = false

		let imageConfig1 = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40), scale: .large)
		var myPauseImage = UIImage(systemName: "play.circle", withConfiguration: imageConfig1)
		playButton.setImage(myPauseImage, for: .normal)
		
		if completingAllItem {
			timeSetInSettings = nil
		} else {
			collectView.reloadData()
			HousieCollection.numbersArray = []
		}
	}
	
	@objc func openSettings() {
		let settings = SettingViewController()
		settings.delegate = self
		if let time = timeSetInSettings {
			settings.defaultTime = String(time)
		}
		settings.audioSegment.isOn = shouldSpeak
		self.present(settings, animated: true, completion: nil)
	}
	
	let collectView : UICollectionView = {
		let lay = UICollectionViewFlowLayout()
		lay.minimumInteritemSpacing = 10
		let p = UICollectionView(frame: .zero, collectionViewLayout: lay)
		p.translatesAutoresizingMaskIntoConstraints = false
		p.isScrollEnabled = false
		return p
	}()
	
	let nextButton : UIButton = {
		let p = UIButton(type: .custom)
		p.translatesAutoresizingMaskIntoConstraints = false
		let imageConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20), scale: .large)
		var myImage = UIImage(systemName: "forward.fill", withConfiguration: imageConfig)
		p.setImage(myImage, for: .normal)
		p.isEnabled = false
		p.addTarget(self, action: #selector(nextItem), for: .touchUpInside)
		return p
	}()
	
	@objc func nextItem() {

		var arrCount = HousieCollection.numbersArray.count
		print(HousieCollection.numbersArray)
		if currentIndexToShow == -1 {
			currentIndexToShow = 0
		}
		if let item = currentIndexToShow,  item <= arrCount - 1 {
			currentIndexToShow! += 1
			prevButton.isEnabled = true
			if currentIndexToShow == arrCount {
				nextButton.isEnabled = false
				return
			}
			print("current INdedx for next ",currentIndexToShow)
			if let obj = shNumObj ,uv3.subviews.contains(obj.view) {
				
				obj.number = String(HousieCollection.numbersArray[currentIndexToShow!])
				speakNumber(num: obj.number!)
				timerForRemovingNumber?.invalidate()
				print(obj.number)
				print("in the if part top of next")
			} else {
				
				var shNum = ShowNumberViewController()
				shNum.number = String(HousieCollection.numbersArray[currentIndexToShow!])
				shNumObj = shNum
				speakNumber(num: shNum.number!)
				print("in the else part top")
				uv3.addSubview(shNum.view)
				uv3.bringSubviewToFront(shNum.view)
			}
			if currentIndexToShow! + 1 == arrCount {
				nextButton.isEnabled = false
			}
		}
	}
	
	let prevButton : UIButton = {
		let p = UIButton(type: .custom)
		p.translatesAutoresizingMaskIntoConstraints = false
		let imageConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20), scale: .large)
		var myImage = UIImage(systemName: "backward.fill", withConfiguration: imageConfig)
		p.setImage(myImage, for: .normal)
		p.isEnabled = false
		p.addTarget(self, action: #selector(prevItem), for: .touchUpInside)
		return p
	}()
	
	@objc func prevItem() {
		
		nextButton.isEnabled = true
		
		if let time = timeSetInSettings, buttonState == true {
			buttonState = !buttonState
			let imageConfig1 = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40), scale: .large)
			var myPauseImage = UIImage(systemName: "play.circle", withConfiguration: imageConfig1)
			playButton.setImage(myPauseImage, for: .normal)
			timerForRemovingNumber?.invalidate()
//			return
		}
//		prevButton.isEnabled = false

		var arrCount = HousieCollection.numbersArray.count
		print(HousieCollection.numbersArray)
		
		if let item = currentIndexToShow, arrCount > 0, item >= 0 {
			print(currentIndexToShow, "  currentIndex")
			if item == arrCount  {
				currentIndexToShow = arrCount - 1
			}
			if currentIndexToShow != -1 {
				currentIndexToShow! -= 1
			}
			if currentIndexToShow == -1 {
				prevButton.isEnabled = false
				return
			}
			if let obj = shNumObj ,uv3.subviews.contains(obj.view) {
				obj.number = String(HousieCollection.numbersArray[currentIndexToShow!])
				print(obj.number)
				speakNumber(num: obj.number!)
				timerForRemovingNumber?.invalidate()
				print("in the if part top")
			} else {
				var shNum = ShowNumberViewController()
				shNum.number = String(HousieCollection.numbersArray[currentIndexToShow!])
				shNumObj = shNum
				speakNumber(num: shNum.number!)
				print("in the else part top")
				uv3.addSubview(shNum.view)
				uv3.bringSubviewToFront(shNum.view)
			}
			if currentIndexToShow == 0 {
				prevButton.isEnabled = false
//				return
			}
			
			return
		}
		
		if arrCount > 1 && currentIndexToShow == nil {
			prevButton.isEnabled = true
			if let obj = shNumObj ,uv3.subviews.contains(obj.view) {
				currentIndexToShow = arrCount - 2
				obj.number = String(HousieCollection.numbersArray[currentIndexToShow!])
				speakNumber(num: obj.number!)
				timerForRemovingNumber?.invalidate()
				print("in the if part bottom")
			} else {
				currentIndexToShow = arrCount - 1
				var shNum = ShowNumberViewController()
				shNum.number = String(HousieCollection.numbersArray[currentIndexToShow!])
				shNumObj = shNum
				speakNumber(num: shNum.number!)
				print("in the else part bottom")
				uv3.addSubview(shNum.view)
				uv3.bringSubviewToFront(shNum.view)
			}
		}
		
 	}
	
	override func viewDidLoad() {
		collectView.dataSource = self
		collectView.delegate = self
		self.view.backgroundColor = UIColor.green
		settingButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 35), forImageIn: .normal)

		// Register cell classes
		collectView.backgroundColor = UIColor.lightText
		collectView.register(HousieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		addSubViews()
		updateCons()
	}

	

	
	

	
	private var timerNotSet = true
	
	// MARK: UICollectionViewDataSource
	private var ht: Int = 0
	private var wt: Int = 0
	
}



extension HousieCollection {
	@objc func tappedButton() {
		if let time = timeSetInSettings {
			buttonState = !buttonState
		}
		currentIndexToShow = nil
		if let time = timeSetInSettings, !buttonState {
			let imageConfig1 = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40), scale: .large)
			var myPauseImage = UIImage(systemName: "play.circle", withConfiguration: imageConfig1)
			playButton.setImage(myPauseImage, for: .normal)
			timerForRemovingNumber?.invalidate()
			return
		}
		showNumber()
	}
	
	func pauseItIfRequired() {
		if let time = timeSetInSettings, buttonState {
			let imageConfig1 = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40), scale: .large)
			var myPauseImage = UIImage(systemName: "pause.circle", withConfiguration: imageConfig1)
			playButton.setImage(myPauseImage, for: .normal)
		}
	}
	
	@objc func showNumber() {
		if HousieCollection.numbersArray.count > 0 {
			prevButton.isEnabled = true
		}
		// Disabling the next button when we tap on play button
		nextButton.isEnabled = false
		pauseItIfRequired()
		print("Button is Tapped")
		var q = arc4random_uniform(90)
		q = q + 1
		print(q)
		var pl = String(q)
		while true {
			if (HousieCollection.numbersArray).contains(pl) {
				q = arc4random_uniform(90)
				q = q + 1
				print(q)
				pl = String(q)
				if HousieCollection.numbersArray.count == 90 {
					var al = UIAlertAction(title: "heya", style: .default, handler: nil)
					var qw = UIAlertController(title: "Completed", message: "Hurray all completed.\n Pls reset to continue again.", preferredStyle: .actionSheet)
					qw.addAction(al)
					self.show(qw, sender: nil)
					resetData(completingAllItem: true)
					return
				}
			} else {
				HousieCollection.numbersArray.append(pl)
				break
			}
		}
		
		speakNumber(num: pl)
		///TODO - MODULARIZE
		//showTheNumber(num : pl)
		print("Entering the check")
		if let obj = shNumObj ,uv3.subviews.contains(obj.view) {
			obj.number = String(pl)
			timerForRemovingNumber?.invalidate()
			print("in the if part")
		} else {
			var shNum = ShowNumberViewController()
			shNum.number = String(pl)
			shNumObj = shNum
			print("in the else part")
			uv3.addSubview(shNum.view)
			uv3.bringSubviewToFront(shNum.view)
		}
		print("PL==",pl)
		print("Entering exiting checlk")
		var rowSection = findRowAndSection(num: Int(pl)!)
		var cd = IndexPath.init(row: rowSection.row, section: rowSection.section)
		var cell = collectView.cellForItem(at: cd)
		cell?.backgroundColor = UIColor.purple

		if let time = timeSetInSettings {
			timerForRemovingNumber = Timer(timeInterval: TimeInterval(time), target: self, selector: #selector(showNumber), userInfo: nil, repeats: false)
			RunLoop.main.add(timerForRemovingNumber!, forMode: .common)
		}
		
	}
	
	func speakNumber(num: String) {
		
		if shouldSpeak {
			lock.lock()
			let utterance = AVSpeechUtterance(string: num)
			utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
			utterance.rate = AVSpeechUtteranceDefaultSpeechRate
			let synthesizer = AVSpeechSynthesizer()
			synthesizer.speak(utterance)
			lock.unlock()
		}
		
	}
	
	
//	func to remove the shown number
	@objc func removeMe() {
		guard let obj = shNumObj else {
			print("Could not find the number view")
			return
		}
		//timerForRemovingNumber?.invalidate()
		obj.view.removeFromSuperview()
	}

	func findRowAndSection(num: Int) -> (row: Int,section: Int) {
		var row = 0
		var section = 0
		//For section
		section = num/10
		if num%10 == 0 {
			section -= 1
		}
		//For row
		row = num%10 - 1
		if row == -1 {
			row = 9
		}
		return (row: row,section: section)
	}
	
	func calculateSizeOfCell() {
		print(collectView.bounds.width,"  polo  ",collectView.bounds.height)
		for i in 10...100 {
			if (((10 * i) + 90) >= Int(collectView.bounds.width)) {
				wt = i-2
				break
			}
		}
		
		for i in 10... {
			if ((9 * i + 80) >= Int(collectView.bounds.height)) {
				ht = i-2
				break
			}
		}
		print(wt,"  ",ht)
	}
	
}

//MARK: CollectionView DataSource
extension HousieCollection {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		calculateSizeOfCell()
		print("in number of sectuions")
		return 9
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of items
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HousieCollectionViewCell
		cell.backgroundColor = .systemGray6
		cell.layer.cornerRadius = 5
		cell.layer.masksToBounds = true
		cell.clipsToBounds = true
		cell.backgroundColor = .systemBlue
		let p = Int(indexPath.row) + (Int(indexPath.section) * 10) + 1
		cell.label.text = String(p)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: wt, height: ht)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
}


// MARK: Contains Settings Info
extension HousieCollection : SettingsData {
	func sendSettingsData(_ data: [String : Any]) {
		if let audio = data["audio"] as? Bool {
			shouldSpeak = audio
		}
		if let timer = data["timer"] as? Bool {
			if timer {
				if let time = data["time"] as? String {
					timeSetInSettings = Int(time)
				}
			} else {
				timeSetInSettings = nil
			}
		}
	}
}

//MARK: Adding SubViews and constraints
extension HousieCollection {
	func updateCons(){
		landscape = [
			uv1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			uv1.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
			uv1.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			uv1.trailingAnchor.constraint(equalTo: uv2.leadingAnchor),
			uv1.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
			
			
			uv2.leadingAnchor.constraint(equalTo: uv1.trailingAnchor),
			uv2.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
			uv2.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
			uv2.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			
			uv3.leadingAnchor.constraint(equalTo: uv1.leadingAnchor, constant: 10),
			uv3.trailingAnchor.constraint(equalTo: uv1.trailingAnchor, constant: -10),
			uv3.topAnchor.constraint(equalTo: uv1.topAnchor, constant: 10),
			
			uv4.topAnchor.constraint(equalTo: uv3.bottomAnchor, constant: 5),
			uv4.leadingAnchor.constraint(equalTo: uv1.leadingAnchor, constant: 10),
			uv4.trailingAnchor.constraint(equalTo: uv1.trailingAnchor, constant: -10),
			uv4.bottomAnchor.constraint(equalTo: uv1.bottomAnchor, constant: 0),
			
			nextButton.topAnchor.constraint(equalTo: uv4.topAnchor, constant: 8),
			nextButton.trailingAnchor.constraint(equalTo: uv4.trailingAnchor, constant: -10),
			
			prevButton.topAnchor.constraint(equalTo: uv4.topAnchor, constant: 8),
			prevButton.leadingAnchor.constraint(equalTo: uv4.leadingAnchor, constant: 10),
			
			titleLabel.centerXAnchor.constraint(equalTo: uv4.centerXAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: uv4.centerYAnchor),
			
			collectView.topAnchor.constraint(equalTo: uv3.topAnchor, constant: 0),
			collectView.leadingAnchor.constraint(equalTo: uv3.leadingAnchor, constant: 0),
			collectView.trailingAnchor.constraint(equalTo: uv3.trailingAnchor, constant: 0),
			collectView.bottomAnchor.constraint(equalTo: uv3.bottomAnchor, constant: 0),
			collectView.heightAnchor.constraint(equalTo: uv1.heightAnchor, multiplier: 0.85),
			
			playButton.centerXAnchor.constraint(equalTo: uv2.centerXAnchor),
			playButton.centerYAnchor.constraint(equalTo: uv2.centerYAnchor),
			playButton.heightAnchor.constraint(equalToConstant: 50),
			playButton.widthAnchor.constraint(equalToConstant: 50),
			
			resetButton.topAnchor.constraint(equalTo: uv2.topAnchor, constant: 10),
			resetButton.centerXAnchor.constraint(equalTo: uv2.centerXAnchor),
			resetButton.heightAnchor.constraint(equalToConstant: 50),
			resetButton.widthAnchor.constraint(equalToConstant: 50),
			
			
			settingButton.bottomAnchor.constraint(equalTo: uv2.bottomAnchor, constant: -10),
			settingButton.centerXAnchor.constraint(equalTo: uv2.centerXAnchor),
			settingButton.heightAnchor.constraint(equalToConstant: 50),
			settingButton.widthAnchor.constraint(equalToConstant: 50),
			
		]
		NSLayoutConstraint.activate(landscape)
	}
	
	func addSubViews() {
		self.view.addSubview(uv1)
		self.view.addSubview(uv2)
		
		uv1.addSubview(uv3)
		uv1.addSubview(uv4)
		
		uv3.addSubview(collectView)
		uv3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeMe)))
		uv3.isUserInteractionEnabled = true
		
		uv4.addSubview(nextButton)
		uv4.addSubview(prevButton)
		uv4.addSubview(titleLabel)
		
		uv2.addSubview(playButton)
		uv2.addSubview(resetButton)
		uv2.addSubview(settingButton)
	}
}


//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		print(indexPath)
//		// var cell = collectionView.cellForItem(at: indexPath)
//		// cell?.backgroundColor = UIColor.systemBlue
//	}


//	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//		print("adaptive type")
//		return .none
//	}


//	func showTheNumber(num : String) {
//
//	}


// shNum.preferredContentSize = CGSize(width: 400, height: 100)
//		shNum.modalPresentationStyle = .overCurrentContext
//		shNum.modalTransitionStyle = .crossDissolve
//		shNumObj!.number =
//		shNum.view.frame = CGRect(x: 0, y: 100, width: 100, height: 200)




//		shNum.modalPresentationStyle = .overCurrentContext
//		shNum.modalTransitionStyle = .crossDissolve
//		shNum.preferredContentSize = CGSize(width: 100, height: 200)
//        shNum.popoverPresentationController?.permittedArrowDirections = .
//        shNum.popoverPresentationController?.delegate = self
//        shNum.popoverPresentationController?.sourceView = uv1 as! UIView;       shNum.popoverPresentationController?.sourceRect = CGRect(x: uv1.frame.midX-50, y: uv1.frame.midY, width: 0, height: 0)
//		present(shNum, animated: true, completion: nil)


//print("clicked me")



//var cd = IndexPath.init(row: 0, section: 7)
//var cell = collectView.cellForItem(at: cd)
//cell?.backgroundColor = UIColor.red

//        sleep(5)
//        playButton.setImage(UIImage.init(named: "play-1"), for: .normal)

//		DispatchQueue.main.perform(, with: shNum, afterDelay: 2)
//		perform(#selector(removeMe), with: nil, afterDelay: 10)


//override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//	print("inthe view will transition")
//	//collectView.reloadData()
//	//        collectView.setNeedsDisplay()
//	//collectView.setNeedsLayout()
//}


//override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//	print("TraITCOLLECTIONDIDCHANGE")
//	print(UIFont.systemFontSize,"  ",traitCollection.preferredContentSizeCategory)
//	//c = c- 1
//
//		print(UIFont.systemFontSize)
//		if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
//			collectView.reloadData()
//		}
//		collectView.reloadData()
//}


//	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//		print("in the will transition")
//		collectView.reloadData()
//	}
	
