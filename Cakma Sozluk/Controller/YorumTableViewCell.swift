//
//  YorumTableViewCell.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 3.11.2024.
//

import UIKit
import FirebaseAuth

protocol YorumDelegate {
    func secenelerYorumDelegate(yorum : Yorum)
}

class YorumTableViewCell: UITableViewCell {

    
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var eklenmeTarihiLabel: UILabel!
    @IBOutlet weak var yorumTextLabel: UILabel!
    @IBOutlet weak var editImageView: UIImageView!
    var secilenYorum : Yorum!
    var delegate : YorumDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func gorunumAyarla(yorum : Yorum , delegate : YorumDelegate?) {
        secilenYorum = yorum
        self.delegate = delegate
        kullaniciAdiLabel.text = yorum.kullaniciAdi
        eklenmeTarihiLabel.text = showDate(date: yorum.eklenmeTarihi)
        yorumTextLabel.text = yorum.yorumText
        editImageView.isHidden = true
        
        if yorum.kullaniciId == Auth.auth().currentUser?.uid {
            editImageView.isHidden = false
            editImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(editImageViewTapped))
            editImageView.addGestureRecognizer(tap)
        }
    }
    
    @objc func editImageViewTapped(){
        delegate?.secenelerYorumDelegate(yorum: secilenYorum)
    }
    
    func showDate(date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
}
