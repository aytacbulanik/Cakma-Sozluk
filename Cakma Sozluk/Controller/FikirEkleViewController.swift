//
//  ViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 30.10.2024.
//

import UIKit

class FikirEkleViewController: UIViewController {

    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var fikirTextView: UITextView!
    @IBOutlet weak var paylasButtonOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paylasButtonOut.layer.cornerRadius = 10
        fikirTextView.layer.cornerRadius = 10
    }

    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        
    }
    @IBAction func paylasButtonPressed(_ sender: UIButton) {
        
    }
    
}



