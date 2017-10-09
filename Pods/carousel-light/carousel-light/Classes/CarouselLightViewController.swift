//
//  CarouselLightViewController.swift
//  carousel-light
//
//  Created by Shaheen Ghiassy on 10/1/17.
//

import UIKit
import AirGap

public class CarouselLightViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        
        let image = UIImage(named: "homepage", in:Bundle(for: type(of: self)), compatibleWith:nil)
        let imageView = UIImageView(image: image)
        
        self.view.addSubview(imageView)
        imageView.frame = self.view.frame
        imageView.isUserInteractionEnabled = true
        let dealtap = UITapGestureRecognizer(target: self, action: #selector(self.userDidSelectDeal(sender:)))
        imageView.addGestureRecognizer(dealtap)
        
        let clickOverlay = UIView(frame:CGRect(x: 0, y: imageView.frame.size.height - 150, width: imageView.frame.size.width, height: 150))
        clickOverlay.backgroundColor = .clear
        clickOverlay.isUserInteractionEnabled = true
        self.view.addSubview(clickOverlay)
        let moretap = UITapGestureRecognizer(target: self, action: #selector(self.userDidSelectMore(sender:)))
        clickOverlay.addGestureRecognizer(moretap)
    }
    
    @objc func userDidSelectDeal(sender: UITapGestureRecognizer) {
        Browser.post("mga.groupon.com/log", body: ["message" : "GRP420: userDidSelectDeal"])
        Browser.show("dealdetails.groupon.com/deals/gl-pompeii-the-exhibition-and-the-oregon-museum-of-science-and-industry-omsi-1")
    }
    
    @objc func userDidSelectMore(sender: UITapGestureRecognizer) {
        Browser.post("mga.groupon.com/log", body: ["message" : "GRP420: userDidSelectMore"])
        Browser.show("carousel.groupon.com")
    }
    
}

