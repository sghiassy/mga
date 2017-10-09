//
//  Toolbar.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import UIKit

class Toolbar: UIView, UITextFieldDelegate {
    
    var addressBar: UITextField?
    var onUserEnteredNewAddress: ((_: String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        self.addressBar = UITextField(frame: CGRect(x: 10, y: 25, width: self.frame.size.width - 25, height: self.frame.size.height - 30))
        self.addressBar?.delegate = self
        self.addressBar?.font = .systemFont(ofSize: 12)
        self.addressBar?.textColor = .gray
        self.addressBar?.backgroundColor = .white
        self.addressBar?.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:20));
        self.addressBar?.leftViewMode = .always;
        self.addSubview(self.addressBar!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("not implemeneted")
    }
    
    public class func height() -> CGFloat {
        return 50
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.onUserEnteredNewAddress?(textField.text ?? "")
        return true
    }
    
}
