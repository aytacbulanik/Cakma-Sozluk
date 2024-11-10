//
//  YorumDuzenleViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 10.11.2024.
//

import UIKit
import FirebaseFirestore

class YorumDuzenleViewController: UIViewController {

    @IBOutlet weak var yorumTextView: UITextView!
    @IBOutlet weak var yorumGuncelleButtonOut: UIButton!
    
    var yorumVerisi : (gelenYorum : Yorum , gelenFikir : Fikir)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yorumGuncelleButtonOut.layer.cornerRadius = 6
        yorumTextView.layer.cornerRadius = 6
        if let yorumVerisi {
            yorumTextView.text = yorumVerisi.gelenYorum.yorumText
        }
    }
    

    @IBAction func guncelleButtonPressed(_ sender: Any) {
        guard let yorumText = yorumTextView.text else { return }
        guard let yorumVerisi else { return }
        Firestore.firestore().collection(FIKIRLER).document(yorumVerisi.gelenFikir.documentId).collection(YORUMLAR).document(yorumVerisi.gelenYorum.documentId).updateData([YORUMTEXT : yorumText]) { error in
            if let error {
                print("Error updating yorum: \(error.localizedDescription)")
            } else {
                print("Yorum updated successfully")
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    

}
