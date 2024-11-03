//
//  UyeOlViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 3.11.2024.
//

import UIKit

class UyeOlViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    @IBOutlet weak var uyeOlButtonOut: UIButton!
    
    @IBOutlet weak var vazgeçButtonOut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        uyeOlButtonOut.layer.cornerRadius = 6
        vazgeçButtonOut.layer.cornerRadius = 6
    }
    
    @IBAction func uyeOlButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func vazgecButtonPressed(_ sender: UIButton) {
    }
    
    
}
