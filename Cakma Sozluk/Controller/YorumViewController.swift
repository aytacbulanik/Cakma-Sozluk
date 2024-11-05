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
    var yorumListener : ListenerRegistration!
    var kullaniciAdi : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fikirRef = Firestore.firestore().collection(FIKIRLER).document(secilenFikir.documentId)
        if let adi = Auth.auth().currentUser?.displayName {
            kullaniciAdi = adi
        }
        
        self.view.klavyeTasima()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getYorum()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if yorumListener != nil {
            yorumListener.remove()
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
    func getYorum() {
        Firestore.firestore().collection(FIKIRLER).document(secilenFikir.documentId).collection(YORUMLAR).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.yorumArray.removeAll(keepingCapacity: true)
                self.yorumArray = Yorum.yorumlariGetir(snapShot: querySnapshot)
                self.tableView.reloadData()
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
