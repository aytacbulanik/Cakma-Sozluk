//
//  UyeOlViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 3.11.2024.
//

import UIKit
import FirebaseAuth

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
        guard let email = emailTextField.text , let password = passwordTextField.text , let passwordAgain = passwordAgainTextField.text else { return }
        if password != passwordAgain {
            print("Şifreler uyuşmuyor")
            return
        }
        Auth.auth().createUser(withEmail: email, password: passwordAgain) { AuthDataResult, error in
            if let error {
                print("Hata: \(error.localizedDescription)")
                return
            } else {
                print("kullanıcı oluşturuldu")
            }
            
        }
        
    }
    
    @IBAction func vazgecButtonPressed(_ sender: UIButton) {
    }
    
    
}
