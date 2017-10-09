//
//  CarouselViewController.swift
//  carousel
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import UIKit
import AirGap

public class CarouselViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue

        // Setup Background Image
        let image = UIImage(named: "homepage", in:Bundle(for: type(of: self)), compatibleWith:nil)
        let imageView = UIImageView(image: image)
        self.view.addSubview(imageView)
        imageView.frame = self.view.frame
        
        // Setup Top Deal Click
        let deal1Overlay = UIView(frame: CGRect(x: 0, y: 90, width: self.view.frame.size.width, height: 280))
        let deal1Tap = UITapGestureRecognizer(target: self, action: #selector(self.userDidPressTopDealCardDidPressBottomDealCard(sender:)))
        deal1Overlay.backgroundColor = .clear
        deal1Overlay.isUserInteractionEnabled = true
        deal1Overlay.addGestureRecognizer(deal1Tap)
        self.view.addSubview(deal1Overlay)
        
        // Setup Bottom Deal Click
        let deal2Overlay = UIView(frame: CGRect(x: 0, y: 390, width: self.view.frame.size.width, height: 300))
        let deal2Tap = UITapGestureRecognizer(target: self, action: #selector(self.userDidPressBottomDealCard(sender:)))
        deal2Overlay.backgroundColor = .clear
        deal2Overlay.isUserInteractionEnabled = true
        deal2Overlay.addGestureRecognizer(deal2Tap)
        self.view.addSubview(deal2Overlay)
    }
    
    @objc func userDidPressTopDealCardDidPressBottomDealCard(sender: UITapGestureRecognizer) {
        Browser.post("mga.groupon.com/log", body: ["message" : "GRP420: userDidPressTopDealCardDidPressBottomDealCard"])
        Browser.show("dealdetails.groupon.com/deals/gl-pompeii-the-exhibition-and-the-oregon-museum-of-science-and-industry-omsi-1")
    }
    
    @objc func userDidPressBottomDealCard(sender: UITapGestureRecognizer) {
        Browser.post("mga.groupon.com/log", body: ["message" : "GRP420: userDidPressBottomDealCard"])
        Browser.show("dealdetails.groupon.com/deals/beavercreek-armory-range-5")
    }

}
