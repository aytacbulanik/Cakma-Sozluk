//
//  FikirTableViewCell.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 31.10.2024.
//

import UIKit

class FikirTableViewCell: UITableViewCell {

    
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var eklenmeTarihiLabel: UILabel!
    @IBOutlet weak var fikirTextLabel: UILabel!
    @IBOutlet weak var begeniImageView: UIImageView!
    @IBOutlet weak var begeniSayisiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func gorunumAyarla(fikir : Fikir) {
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
   

}
