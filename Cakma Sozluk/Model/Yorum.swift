//
//  Yorum.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 3.11.2024.
//

import Foundation

class Yorum {
    private(set) var kullaniciAdi : String!
    private(set) var eklenmeTarihi : Date!
    private(set) var yorumText : String!
    
    init(kullaniciAdi: String!, eklenmeTarihi: Date!, yorumText: String!) {
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.yorumText = yorumText
    }
}
