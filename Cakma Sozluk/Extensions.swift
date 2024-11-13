    //
    //  Extensions.swift
    //  Cakma Sozluk
    //
    //  Created by Aytaç Bulanık on 14.11.2024.
    //

import Foundation
import Firebase

extension CollectionReference {
    
    func yeniWhereSorgum() -> Query {
        let tarihVerileri = Calendar.current.dateComponents([.year,.month,.day], from: Date())
        guard let bugun = Calendar.current.date(from: tarihVerileri),
              let bitis = Calendar.current.date(byAdding: .hour, value: 24, to: bugun) ,
              let baslangic = Calendar.current.date(byAdding: .day, value: -2, to: bugun) else {
            fatalError("Belirtilen tarih aralıklarında bir kayıt bulunamadı")
        }
        
        return whereField(EKLENMETARIHI, isLessThanOrEqualTo: bitis).whereField(EKLENMETARIHI, isGreaterThanOrEqualTo: baslangic).limit(to: 30).order(by: BEGENISAYISI, descending: true)
    }
}
