//
//  buttn.swift
//  Demo for houseie
//
//  Created by Mohan on 12/10/20.
//  Copyright © 2020 Mohan. All rights reserved.
//

import Foundation

import UIKit

class buttn: UIViewController {
    let p: UILabel = {
       let pq = UILabel()
        pq.translatesAutoresizingMaskIntoConstraints = false
        pq.numberOfLines = 0
        pq.isAccessibilityElement = true
        pq.font = .preferredFont(forTextStyle: .body)
        pq.adjustsFontForContentSizeCategory = true
        return pq
    }()
    
    override func viewWillLayoutSubviews() {
        p.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
                     p.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
                     p.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -300).isActive = true
    }
    override func viewDidLayoutSubviews() {
        countLabelLines(label: p)
        print("didlay")
        //print(p.contentEdgeInsets)
        //print(p.titleInsets," titleinsets")
        //print(p.contentInsets,"contentinsets")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        
        // Do any additional setup after loading the view.
        self.view.addSubview(p)
//        p.text = "s\nnfpadisnfpsifetysdrfdfgsdgdfgdfsgdfsnsd,\nkfnaps\njsdbgn"
      //  p.attributedText = NSAttributedString.init(string: "s\nnfpadisnfpsifetysdrfdfgsdgdfgdfsgdfsnsd,\nkfnaps\njsdbgn", attributes: [:])
//        p.attributedText = NSAttributedString.init(string: "MOH\nABAS", attributes: [NSAttributedString.Key.foregroundColor : UIColor.green,
//      NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
//        ])
//        p.attributedText = NSAttributedString(data: "<b><i>text</i></b>".dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,options: [NSAttributedString.DocumentAttributeKey: NSAttributedString.DocumentReadingOptionKey],
//                           documentAttributes: nil)
        //print(countLabelLines(label: p))
    }
   
    
    
    func countLabelLines(label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout

        let myText = label.text! as NSString

        let rect = CGSize(width: p.intrinsicContentSize.width, height: CGFloat.greatestFiniteMagnitude)
        print(p.intrinsicContentSize)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: p.font], context: nil)
        
        print(label.intrinsicContentSize.width,CGFloat.greatestFiniteMagnitude)
        print(Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight)))
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
   
    
    
}
