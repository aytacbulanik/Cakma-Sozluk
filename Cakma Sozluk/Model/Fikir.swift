//
//  Fikir.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 30.10.2024.
//

import Foundation
import Firebase

class Fikir {
    private(set) var kullaniciAdi : String
    private(set) var fikirText : String
    private(set) var categoryName : String
    private(set) var eklenmeTarihi : Date
    private(set) var begeniSayisi : Int
    private(set) var yorumSayisi : Int
    private(set) var documentId : String
    private(set) var kullaniciId : String
    
    init(kullaniciAdi: String, fikirText: String, categoryName: String, eklenmeTarihi: Date, begeniSayisi: Int, yorumSayisi: Int,documentId: String, kullaniciId : String) {
        self.kullaniciAdi = kullaniciAdi
        self.fikirText = fikirText
        self.categoryName = categoryName
        self.eklenmeTarihi = eklenmeTarihi
        self.begeniSayisi = begeniSayisi
        self.yorumSayisi = yorumSayisi
        self.documentId = documentId
        self.kullaniciId = kullaniciId
    }
    
    static func getFikir(snapShot : QuerySnapshot?) -> [Fikir] {
        var fikirler = [Fikir]()
        guard let snap = snapShot else { return fikirler}
        for veri in snap.documents {
            let documentID = veri.documentID
            let data = veri.data()
            let kullaniciAdi = data[KULLANICIADI] as? String ?? ""
            let categoryName = data[CATEGORYNAME] as? String ?? ""
            let fikirText = data[FIKIRTEXT] as? String ?? ""
            let begeniSayisi = data[BEGENISAYISI] as? Int ?? -1
            let yorumSayisi = data[YORUMSAYISI] as? Int ?? -1
            let serverDate = data[EKLENMETARIHI] as? Timestamp ?? Timestamp()
            let eklenmeTarihi = serverDate.dateValue()
            let kullaniciId = data[KULLANICIID] as? String ?? ""
            let newFikir = Fikir(kullaniciAdi: kullaniciAdi, fikirText: fikirText, categoryName: categoryName, eklenmeTarihi: eklenmeTarihi, begeniSayisi: begeniSayisi, yorumSayisi: yorumSayisi , documentId: documentID,kullaniciId: kullaniciId)
            fikirler.append(newFikir)
        }
        return fikirler
    }
}
