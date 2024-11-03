//
//  YorumViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 3.11.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class YorumViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yorumField: UITextField!
    
    var secilenFikir : Fikir!
    var yorumArray = [Yorum]()
    var fikirRef : DocumentReference!
    var kullaniciAdi : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fikirRef = Firestore.firestore().collection(FIKIRLER).document(secilenFikir.documentId)
        if let adi = Auth.auth().currentUser?.displayName {
            kullaniciAdi = adi
        }
    }
    

   
    @IBAction func yorumSendButtonPressed(_ sender: UIButton) {
        guard let yorumText = yorumField.text else { return }
        
        Firestore.firestore().runTransaction ({ (transection, errorPointer)  -> Any? in
            let secilenFikirKayit : DocumentSnapshot
            do {
                try secilenFikirKayit = transection.getDocument(Firestore.firestore() .collection(FIKIRLER).document(self.secilenFikir.documentId))
            } catch let hata as NSError {
                print(hata.localizedDescription)
                return nil
            }
            
            guard let eskiYorumSAyisi = secilenFikirKayit.data()?[YORUMSAYISI] as? Int else { return nil }
            transection.updateData([YORUMSAYISI : eskiYorumSAyisi + 1], forDocument: self.fikirRef)
            let yeniYorumRef = Firestore.firestore().collection(FIKIRLER).document(self.secilenFikir.documentId).collection(YORUMLAR).document()
            transection.setData([
                YORUMTEXT : yorumText,
                EKLENMETARIHI : FieldValue.serverTimestamp(),
                KULLANICIADI : self.kullaniciAdi!
            ], forDocument: yeniYorumRef)
            
            return nil
        }) { nesne, error in
            if let error {
                print(error.localizedDescription)
            } else {
                self.yorumField.text = ""
            }
        }

        
    }
    
}

extension YorumViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yorumArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "yorumCell", for: indexPath) as? YorumTableViewCell {
            let gecerliYorum = yorumArray[indexPath.row]
            cell.gorunumAyarla(yorum: gecerliYorum)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
