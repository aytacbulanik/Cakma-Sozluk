//
//  Klavye Ayarlari.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 5.11.2024.
//

import Foundation
import UIKit


extension UIView {
    
    func klavyeTasima() {
            NotificationCenter.default.addObserver(self, selector: #selector(klavyeDegisim(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        
        @objc func klavyeDegisim(_ notification : NSNotification) {
            let sure = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double //klavyenin geçiş süresine eriştik
            let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt //klavyenin eğim ayarlarına eriştik
            let baslangicKlavyeFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue // klavyenin baslangıç konumuna eriştik
            let bitisKlavyeFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue //klavyenin bitiş konumuna eriştik
            let farkY = (bitisKlavyeFrame.origin.y - baslangicKlavyeFrame.origin.y) 
            UIView.animateKeyframes(withDuration: sure, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
                self.frame.origin.y += farkY // burada gideceği konumu hesapladık
            }, completion: nil)
        }

}
