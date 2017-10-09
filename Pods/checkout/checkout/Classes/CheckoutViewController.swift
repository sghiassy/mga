//
//  CheckoutViewController.swift
//  checkout
//
//  Created by Shaheen Ghiassy on 10/2/17.
//

import UIKit
import Alamofire
import AlamofireImage
import AirGap

public class CheckoutViewController: UIViewController {
    
    var sessionId: String
    
    public init(sessionId: String) {
        self.sessionId = sessionId
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        
        let image = UIImage(named: "checkout", in:Bundle(for: type(of: self)), compatibleWith:nil)
        let backgroundImage = UIImageView(image: image)
        self.view.addSubview(backgroundImage)
        backgroundImage.frame = self.view.frame
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: 80, width: 70, height: 70)
        imageView.contentMode = .scaleToFill
        self.view.addSubview(imageView)
        
        let dealTitle = UILabel(frame: CGRect(x: 90, y: 60, width: self.view.frame.size.width - 100, height: 100))
        dealTitle.numberOfLines = 0
        self.view.addSubview(dealTitle)
        
        let backButton = UIButton(type: .custom)
        backButton.backgroundColor = .clear
        backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        Alamofire.request("http://api.groupon.com/api/mobile/US/deals/\(self.sessionId)?client_id=107bf0ad49d8974c400d4dbfa6f03953").responseJSON { response in
            //            debugPrint(response)
            
            if let json = response.result.value as? [String: Any],
                let deal = json["deal"] as? [String: Any],
                let imageURL = deal["largeImageUrl"] as? String,
                let title = deal["title"] as? String {
                DispatchQueue.main.async {
                    let downloadURL = URL(string: imageURL.replacingOccurrences(of: "https", with: "http"))!
                    imageView.af_setImage(withURL: downloadURL)
                    
                    dealTitle.text = title
                }
                
            }
        }
    }
    
    @objc func back() {
        Browser.post("mga.groupon.com/log", body: ["message" : "GRP420: userSelectedBack  for session:\(self.sessionId)"]) // <- This should really be taken care of by middleware
        Browser.back()
    }

}
