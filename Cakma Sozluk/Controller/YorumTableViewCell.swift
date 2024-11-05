//
//  YorumTableViewCell.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 3.11.2024.
//

import UIKit

class YorumTableViewCell: UITableViewCell {

    
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var eklenmeTarihiLabel: UILabel!
    @IBOutlet weak var yorumTextLabel: UILabel!
    @IBOutlet weak var editImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func gorunumAyarla(yorum : Yorum) {
        kullaniciAdiLabel.text = yorum.kullaniciAdi
        eklenmeTarihiLabel.text = showDate(date: yorum.eklenmeTarihi)
        yorumTextLabel.text = yorum.yorumText
    }
    
    func showDate(date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
}
