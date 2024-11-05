//
//  ViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 30.10.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FikirEkleViewController: UIViewController {
    
    let db = Firestore.firestore()
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var fikirTextView: UITextView!
    @IBOutlet weak var paylasButtonOut: UIButton!
    var categoryArray = ["Gündem","Siyaset","Magazin","Spor"]
    var chosenCategory : String = "Gündem"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paylasButtonOut.layer.cornerRadius = 10
        fikirTextView.layer.cornerRadius = 10
        kullaniciAdiLabel.text = Auth.auth().currentUser?.displayName
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        chosenCategory = categoryArray[segmentedController.selectedSegmentIndex]
        
    }
    @IBAction func paylasButtonPressed(_ sender: UIButton) {
        guard let fikirText = fikirTextView.text else { return }
        db.collection(FIKIRLER).addDocument(data: [
            CATEGORYNAME : chosenCategory,
            FIKIRTEXT : fikirText,
            KULLANICIADI : Auth.auth().currentUser?.displayName ?? "",
            BEGENISAYISI : 0,
            YORUMSAYISI : 0,
            EKLENMETARIHI : FieldValue.serverTimestamp(),
            KULLANICIID : Auth.auth().currentUser?.uid ?? ""
        ]) { error  in
            if let error {
                print(error.localizedDescription)
            }
        }
        
    }
}




