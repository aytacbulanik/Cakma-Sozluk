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
    private(set) var documentId : String!
    private(set) var kullaniciId : String!
    
    init(kullaniciAdi: String!, eklenmeTarihi: Date!, yorumText: String!,documentId: String, kullaniciId: String) {
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.yorumText = yorumText
        self.documentId = documentId
        self.kullaniciId = kullaniciId
    }
    
    class func yorumlariGetir(snapShot : QuerySnapshot?) -> [Yorum] {
        var yorumlar = [Yorum]()
        guard let snap = snapShot else { return yorumlar }
        for veri in snap.documents {
            let documentId = veri.documentID
            let data = veri.data()
            let kullaniciAdi = data[KULLANICIADI] as? String ?? ""
            let ts = data[EKLENMETARIHI] as? Timestamp ?? Timestamp()
            let eklenmeTarihi = ts.dateValue()
            let yorumText = data[YORUMTEXT] as? String ?? ""
            let kullaniciId = data[KULLANICIID] as? String ?? ""
            let newYorum = Yorum(kullaniciAdi: kullaniciAdi, eklenmeTarihi: eklenmeTarihi, yorumText: yorumText,documentId: documentId, kullaniciId: kullaniciId)
            yorumlar.append(newYorum)
        }
        
        return yorumlar
    }
}
