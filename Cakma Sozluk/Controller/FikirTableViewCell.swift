    //
    //  FikirTableViewCell.swift
    //  Cakma Sozluk
    //
    //  Created by Aytaç Bulanık on 31.10.2024.
    //

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol FikirDelegate {
    func seceneklerFikirDelegate(fikir: Fikir)
}

class FikirTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var eklenmeTarihiLabel: UILabel!
    @IBOutlet weak var fikirTextLabel: UILabel!
    @IBOutlet weak var begeniImageView: UIImageView!
    @IBOutlet weak var begeniSayisiLabel: UILabel!
    @IBOutlet weak var yorumSayisiLabel: UILabel!
    @IBOutlet weak var yorumImageView: UIImageView!
    
    @IBOutlet weak var editImageView: UIImageView!
    var secilenFikir : Fikir!
    var delegate : FikirDelegate?
    var begeniler = [Begeni]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(begeniTapped))
        begeniImageView.addGestureRecognizer(tap)
        begeniImageView.isUserInteractionEnabled = true
    }
    
    func gorunumAyarla(fikir : Fikir , delegate : FikirDelegate?) {
        self.delegate = delegate
        secilenFikir = fikir
        kullaniciAdiLabel.text = fikir.kullaniciAdi
        begeniImageView.image = UIImage(systemName: "star")
        fikirTextLabel.text = fikir.fikirText
        begeniSayisiLabel.text = String(fikir.begeniSayisi)
        eklenmeTarihiLabel.text = showTarih(zaman: fikir.eklenmeTarihi)
        yorumSayisiLabel.text = String(fikir.yorumSayisi)
        editImageView.isHidden = true
        if fikir.kullaniciId == Auth.auth().currentUser?.uid {
            editImageView.isHidden = false
            editImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(editImgPressed))
            editImageView.addGestureRecognizer(tap)
        }
        begeniSorgu()
    }
    
    @objc func editImgPressed() {
        delegate?.seceneklerFikirDelegate(fikir: secilenFikir)
    }
    
    func showTarih(zaman : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY - HH:mm"
        return formatter.string(from: zaman)
    }
    
    func begeniSorgu() {
        let begeniSorgu = Firestore.firestore().collection(FIKIRLER).document(self.secilenFikir.documentId).collection(BEGENILER).whereField(KULLANICIID, isEqualTo: Auth.auth().currentUser?.uid ?? "")
        
        begeniSorgu.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                self.begeniler =  Begeni.begeniGetir(snapshot: snapshot)
                
                if self.begeniler.count > 0 {
                    self.begeniImageView.image = UIImage(systemName: "star.fill")
                }else {
                    self.begeniImageView.image = UIImage(systemName: "star")
                }
            }
        }
    }
    
    @objc func begeniTapped() {
        Firestore.firestore().runTransaction { transaction, error -> Any? in
            let secilenFikirKayit : DocumentSnapshot
            
            do {
                try secilenFikirKayit =  transaction.getDocument(Firestore.firestore().collection(FIKIRLER).document(self.secilenFikir.documentId))
            } catch let hata as NSError {
                print(hata.localizedDescription)
                return nil
            }
            
            guard let eskiBegeniSayisi = secilenFikirKayit.data()?[BEGENISAYISI] as? Int else {return nil}
            let secilenFikirRef = Firestore.firestore().collection(FIKIRLER).document(self.secilenFikir.documentId)
            
            if self.begeniler.count > 0 {
                transaction.updateData([BEGENISAYISI : eskiBegeniSayisi - 1], forDocument: secilenFikirRef)
                let eskiBegeniRef = Firestore.firestore().collection(FIKIRLER).document(self.secilenFikir.documentId).collection(BEGENILER).document(self.begeniler[0].documentId)
                transaction.deleteDocument(eskiBegeniRef)
            } else {
                transaction.updateData([BEGENISAYISI : eskiBegeniSayisi + 1], forDocument: secilenFikirRef)
                
                let yeniBegeniRef = Firestore.firestore().collection(FIKIRLER).document(self.secilenFikir.documentId).collection(BEGENILER).document()
                transaction.setData([KULLANICIID : Auth.auth().currentUser?.uid ?? ""], forDocument: yeniBegeniRef)
            }
            
            return nil
        } completion: { nesne, error in
            if let error {
                print(error.localizedDescription)
            }
            
            
        }

    }
    
    
}
