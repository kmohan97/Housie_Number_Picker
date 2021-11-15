//
//  CollectViewController.swift
//  Demo for houseie
//
//  Created by Mohan on 04/10/20.
//  Copyright © 2020 Mohan. All rights reserved.
//

import UIKit

class CollectViewController: UIViewController {
    let p: UILabel = {
       let pq = UILabel()
        pq.translatesAutoresizingMaskIntoConstraints = false
        pq.numberOfLines = 0
        pq.isAccessibilityElement = true
        pq.font = .preferredFont(forTextStyle: .body)
        pq.adjustsFontForContentSizeCategory = true
        return pq
    }()
    
    let q: ResizableButton = {
        let pq = ResizableButton(type: .system)
        pq.translatesAutoresizingMaskIntoConstraints = false
        pq.backgroundColor = UIColor.black
        pq.titleLabel!.numberOfLines = 0
        pq.titleLabel?.adjustsFontForContentSizeCategory = true
        pq.titleLabel!.font = .preferredFont(forTextStyle: .body)
        pq.isAccessibilityElement = true
        //pq.setTitle("sfgkjdfgsdfsdfcbcrdfxcgfhbfghfghfghfg ", for: .normal)
        return pq
    }()
    
    override func viewWillLayoutSubviews() {
        p.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
                     p.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
                     p.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -300).isActive = true
    }
    override func viewDidLayoutSubviews() {
        q.titleLabel?.backgroundColor = UIColor.green
        q.titleLabel!.textAlignment = NSTextAlignment.center
        q.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        q.titleLabel?.adjustsFontSizeToFitWidth = true
        //p.attributedText = NSAttributedString.init(string: "s\nnfpadisnfpsifetysdrfdfgsdgdfgdfsgdfsnsd,\nkfnaps\njsdbgn", attributes: [:])
        //   countLabelLines(label: q)
//        q.layoutIfNeeded()
        print(q.intrinsicContentSize, "mohan")
        print("didlay")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        // Do any additional setup after loading the view.
        self.view.addSubview(p)
        //q.titleLabel?.text = "polo"
        //intrinsicContentSize1()
        //print(countLabelLines(label: q))
        print(q.titleLabel?.text,"eff")
    }
   
    
    
    func countLabelLines(label: ResizableButton) -> Int {
        
        let myText = label.titleLabel!.text! as NSString
        //let q1 = intrinsicContentSize1()
        //print("intinsndsac",q1)
        print("real intrinsic", q.intrinsicContentSize)
        let rect = CGSize(width: q.intrinsicContentSize.width, height: CGFloat.greatestFiniteMagnitude)
        
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: q.titleLabel!.font], context: nil)
        
        print(label.intrinsicContentSize.width,CGFloat.greatestFiniteMagnitude)
        print(Int(ceil(CGFloat(labelSize.height) / q.titleLabel!.font.lineHeight)), "nof")
        return Int(ceil(CGFloat(labelSize.height) / q.titleLabel!.font.lineHeight))
    }
    


}

class ResizableButton: UIButton {
    
    public override func layoutSubviews() {
            super.layoutSubviews()
            let width = self.frame.width - self.titleEdgeInsets.left - self.titleEdgeInsets.right - self.contentEdgeInsets.left - self.contentEdgeInsets.right
            if width > 0 {
                self.titleLabel?.preferredMaxLayoutWidth = width
                super.layoutSubviews()
            } else {
              
            }
        }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        print(labelSize, "ls")
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        return desiredButtonSize
    }
}
