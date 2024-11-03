    //
    //  Yorum.swift
    //  Cakma Sozluk
    //
    //  Created by Aytaç Bulanık on 3.11.2024.
    //

import Foundation
import FirebaseFirestore

class Yorum {
    private(set) var kullaniciAdi : String!
    private(set) var eklenmeTarihi : Date!
    private(set) var yorumText : String!
    
    init(kullaniciAdi: String!, eklenmeTarihi: Date!, yorumText: String!) {
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.yorumText = yorumText
    }
    
    class func yorumlariGetir(snapShot : QuerySnapshot?) -> [Yorum] {
        var yorumlar = [Yorum]()
        guard let snap = snapShot else { return yorumlar }
        for veri in snap.documents {
            let data = veri.data()
            let kullaniciAdi = data[KULLANICIADI] as? String ?? ""
            let ts = data[EKLENMETARIHI] as? Timestamp ?? Timestamp()
            let eklenmeTarihi = ts.dateValue()
            let yorumText = data[YORUMTEXT] as? String ?? ""
            let newYorum = Yorum(kullaniciAdi: kullaniciAdi, eklenmeTarihi: eklenmeTarihi, yorumText: yorumText)
            yorumlar.append(newYorum)
        }
        
        return yorumlar
    }
}
