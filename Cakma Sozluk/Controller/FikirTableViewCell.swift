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

   

}
