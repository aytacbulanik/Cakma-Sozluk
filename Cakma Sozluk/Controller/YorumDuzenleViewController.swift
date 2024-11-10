//
//  YorumDuzenleViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 10.11.2024.
//

import UIKit

class YorumDuzenleViewController: UIViewController {

    @IBOutlet weak var yorumTextView: UITextView!
    @IBOutlet weak var yorumGuncelleButtonOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yorumGuncelleButtonOut.layer.cornerRadius = 6
    }
    

    @IBAction func guncelleButtonPressed(_ sender: Any) {
        
        
    }
    

}
