//
//  DealDetailsViewController.swift
//  AirGap
//
//  Created by Shaheen Ghiassy on 10/2/17.
//

import UIKit
import Alamofire
import AlamofireImage
import AirGap

public class DealDetailsViewController: UIViewController {
    
    var dealId: String
    
    public init(dealId: String) {
        self.dealId = dealId
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        
        let image = UIImage(named: "omsideal", in:Bundle(for: type(of: self)), compatibleWith:nil)
        let backgroundImageView = UIImageView(image: image)
        self.view.addSubview(backgroundImageView)
        backgroundImageView.frame = self.view.frame
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 240)
        self.view.addSubview(imageView)
        
        let dealTitle = UILabel(frame: CGRect(x: 20, y: 320, width: self.view.frame.size.width - 20, height: 80))
        dealTitle.numberOfLines = 0
        self.view.addSubview(dealTitle)
        
        let backButton = UIButton(type: .custom)
        backButton.backgroundColor = .clear
        backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let buyButton = UIButton(type: .custom)
        buyButton.backgroundColor = .clear
        buyButton.frame = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 70, width: self.view.frame.size.width / 2, height: 70)
        buyButton.addTarget(self, action: #selector(self.userDidTapBuyButton), for: .touchUpInside)
        self.view.addSubview(buyButton)
        
        Alamofire.request("http://api.groupon.com/api/mobile/US/deals/\(self.dealId)?client_id=107bf0ad49d8974c400d4dbfa6f03953").responseJSON { response in
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
        Browser.back()
    }
    
    @objc func userDidTapBuyButton() {
        Browser.post("mga.groupon.com/log", body: ["message" : "GRP420: userDidTapBuyButton for deal\(self.dealId)"])
        Browser.show("http://cart.groupon.com/\(self.dealId)")
    }
}
