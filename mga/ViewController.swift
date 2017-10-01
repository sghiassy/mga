//
//  ViewController.swift
//  mga
//
//  Created by Shaheen Ghiassy on 9/30/17.
//  Copyright © 2017 Shaheen Ghiassy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var text: String
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.blue
        
        let label = UILabel()
        label.text = self.text
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = UIColor.white
        label.frame = CGRect(origin: .zero, size: CGSize.init(width: 400, height: 400))
        self.view.addSubview(label)
    }


}

