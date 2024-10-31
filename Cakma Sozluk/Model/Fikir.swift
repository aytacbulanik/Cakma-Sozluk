//
//  Fikir.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 30.10.2024.
//

import Foundation

class Fikir {
    private(set) var kullaniciAdi : String
    private(set) var fikirText : String
    private(set) var categoryName : String
    private(set) var eklenmeTarihi : Date
    private(set) var begeniSayisi : Int
    private(set) var yorumSayisi : Int
    private(set) var documentId : String
    
    init(kullaniciAdi: String, fikirText: String, categoryName: String, eklenmeTarihi: Date, begeniSayisi: Int, yorumSayisi: Int,documentId: String) {
        self.kullaniciAdi = kullaniciAdi
        self.fikirText = fikirText
        self.categoryName = categoryName
        self.eklenmeTarihi = eklenmeTarihi
        self.begeniSayisi = begeniSayisi
        self.yorumSayisi = yorumSayisi
        self.documentId = documentId
    }
}
