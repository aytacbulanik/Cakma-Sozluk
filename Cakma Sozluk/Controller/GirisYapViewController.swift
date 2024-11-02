//
//  GirisYapViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 3.11.2024.
//

import UIKit
import FirebaseAuth

class GirisYapViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var girisYapButtonOut: UIButton!
    @IBOutlet weak var uyeOlButtonOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        girisYapButtonOut.layer.cornerRadius = 6
        uyeOlButtonOut.layer.cornerRadius = 6
    }
    

    @IBAction func girisYapButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            if let error {
                print(error.localizedDescription)
            } else {
                print(authDataResult?.additionalUserInfo)
            }
        }
        
    }
    

}
