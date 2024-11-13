//
//  Begeni.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 13.11.2024.
//

import Foundation
import Firebase

class Begeni {
    private(set) var kullaniciId : String
    private(set) var documentId : String
    
    init(kullaniciId: String, documentId: String) {
        self.kullaniciId = kullaniciId
        self.documentId = documentId
    }
    
    class func begeniGetir(snapshot : QuerySnapshot?) -> [Begeni] {
        var begeniler = [Begeni]()
        guard let snapshot else { return begeniler }
        for kayit in snapshot.documents {
            let data = kayit.data()
            let kullaniciId = data[KULLANICIID] as? String ?? ""
            let documentId = kayit.documentID
            let begeni = Begeni(kullaniciId: kullaniciId, documentId: documentId)
            begeniler.append(begeni)
        }
        
        
        return begeniler
    }
}
