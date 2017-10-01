//
//  ViewController.swift
//  mga
//
//  Created by Shaheen Ghiassy on 9/30/17.
//  Copyright © 2017 Shaheen Ghiassy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var path: String
    var query: String
    
    init(path: String, query: String) {
        self.path = path
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.blue
        
        let label = UILabel()
        label.text = self.path
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.frame = CGRect(origin: CGPoint.init(x: 0, y: 100), size: CGSize.init(width: UIScreen.main.bounds.width, height: 75))
        self.view.addSubview(label)
        
        let query = UILabel()
        query.text = self.query
        query.font = UIFont.systemFont(ofSize: 20)
        query.textColor = UIColor.white
        query.frame = CGRect(origin: CGPoint.init(x: 0, y: 200), size: CGSize.init(width: UIScreen.main.bounds.width, height: 75))
        self.view.addSubview(query)
    }


}

