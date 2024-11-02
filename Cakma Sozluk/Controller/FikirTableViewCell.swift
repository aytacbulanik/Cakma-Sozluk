    //
    //  FikirTableViewCell.swift
    //  Cakma Sozluk
    //
    //  Created by Aytaç Bulanık on 31.10.2024.
    //

import UIKit
import FirebaseFirestore

class FikirTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var eklenmeTarihiLabel: UILabel!
    @IBOutlet weak var fikirTextLabel: UILabel!
    @IBOutlet weak var begeniImageView: UIImageView!
    @IBOutlet weak var begeniSayisiLabel: UILabel!
    var secilenFikir : Fikir!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(begeniTapped))
        begeniImageView.addGestureRecognizer(tap)
        begeniImageView.isUserInteractionEnabled = true
    }
    
    func gorunumAyarla(fikir : Fikir) {
        secilenFikir = fikir
        kullaniciAdiLabel.text = fikir.kullaniciAdi
        begeniImageView.image = UIImage(systemName: "star")
        fikirTextLabel.text = fikir.fikirText
        begeniSayisiLabel.text = String(fikir.begeniSayisi)
        eklenmeTarihiLabel.text = showTarih(zaman: fikir.eklenmeTarihi)
    }
    
    func showTarih(zaman : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY - HH:mm"
        return formatter.string(from: zaman)
    }
    
    @objc func begeniTapped() {
        Firestore.firestore().collection(FIKIRLER).document(secilenFikir.documentId).setData([
            BEGENISAYISI : secilenFikir.begeniSayisi + 1]
                                                                                             , merge: true)
    }
    
    
}
