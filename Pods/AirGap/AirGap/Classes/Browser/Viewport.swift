//
//  Browser.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import UIKit

public class Viewport: UIViewController {
    
    private let nav: UINavigationController = UINavigationController()
    var toolbar: Toolbar?
    var onUserEnteredNewAddress: ((_: String) -> Void)?
    
    public init() {
        self.nav.isNavigationBarHidden = true
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.nav.view)
        self.nav.view.frame = self.view.bounds
        
        // Setup Toolbar
        self.toolbar = Toolbar(frame: CGRect(x: 0, y: -Toolbar.height(), width: self.view.frame.size.width, height: Toolbar.height()))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.userDidPan(sender:)));
        self.view.addGestureRecognizer(pan)
        self.view.addSubview(self.toolbar!)
        self.toolbar?.onUserEnteredNewAddress =  { (str) in
            self.onUserEnteredNewAddress?(str)
        }
    }
    
    public func updateViewportWithVC(_ vc:UIViewController?, transitionType: BrowserTransitionType = .push) {
        guard let viewcontroller = vc else {
            return
        }

        switch (transitionType) {
        case .none:
            self.nav.pushViewController(viewcontroller, animated: false)
        case .push:
            self.nav.pushViewController(viewcontroller, animated: true)
        case .refresh:
            self.swapTopVCWith(viewcontroller)
        default:
            self.nav.pushViewController(viewcontroller, animated: true)
        }
    }
    
    public func swapTopVCWith(_ vc: UIViewController?) {
        if let newViewController = vc {
            var viewControllers = self.nav.viewControllers
            _ = viewControllers.popLast()
            viewControllers.append(newViewController)
            self.nav.viewControllers = viewControllers
        }
    }
    
    public func pop(animated: Bool = true) {
        self.nav.popViewController(animated: animated)
    }
    
    public var urlBrowserBarText: String {
        get {
            return self.toolbar?.addressBar?.text ?? ""
        }
        
        set {
            self.toolbar?.addressBar?.text = newValue
        }
    }
    
    @objc func userDidPan(sender: UIPanGestureRecognizer) {
        if (sender.state == .changed) {
            let translation = sender.translation(in: self.view)
            
            var y = translation.y
            
            // Only move within a certain range
            if (translation.y > 0) {
                y = 0
            } else if (translation.y < -Toolbar.height()) {
                y = -Toolbar.height()
            }
            
            self.toolbar?.frame.origin.y = y
        }
    }
    
}

