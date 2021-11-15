//
//  ViewController.swift
//  Demo for houseie
//
//  Created by Mohan on 04/10/20.
//  Copyright © 2020 Mohan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    static var pqw : [String] = []
    let but1 : UIButton = {
        let p = UIButton(type: .system)
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = UIColor.green
        //p.addSelector
        p.addTarget(self, action: #selector(pol), for: .touchUpInside)
        return p
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
        self.view.addSubview(but1)
        apply_cons()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("csdfaleld me")
    }
    func apply_cons(){
        NSLayoutConstraint.activate([
            but1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            but1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            but1.widthAnchor.constraint(equalToConstant: 100),
            but1.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc func pol() {
        var q = arc4random_uniform(90)
        q = q + 1
        print(q)
        var pl = String(q)
       while true {
            if (ViewController.pqw).contains(pl){
                q = arc4random_uniform(90)
                q = q + 1
                print(q)
                pl = String(q)
                if ViewController.pqw.count == 90 {
                    var al = UIAlertAction(title: "heya", style: .default, handler: nil)
                    var qw = UIAlertController(title: "completed", message: "hurray all completed", preferredStyle: .actionSheet)
                    qw.addAction(al)
                    self.show(qw, sender: nil)
                    ViewController.pqw = []
                    break
                }
            }else{
                ViewController.pqw.append(pl)
                break
            }
        }
        let utterance = AVSpeechUtterance(string: pl)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.7
        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speak(utterance)
        var v = ShowNumberViewController()
        v.number = String(pl)
       // v.isModalInPresentation = true
//        v.modalPresentationStyle = .
//        v.modalTransitionStyle = .
        self.present(v, animated: true, completion: nil)
        print("clicked me")
    }

}

