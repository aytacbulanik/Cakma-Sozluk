    //
    //  HomeScreenViewController.swift
    //  Cakma Sozluk
    //
    //  Created by Aytaç Bulanık on 30.10.2024.
    //

import UIKit
import FirebaseFirestore

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var db = Firestore.firestore()
    var fikirArray = [Fikir]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getFikir()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.getFikir()
        }
    }
    
    func getFikir() {
        db.collection(FIKIRLER).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                self.fikirArray.removeAll(keepingCapacity: true)
                guard let snap = querySnapshot else { return }
                for veri in snap.documents {
                    let data = veri.data()
                    let kullaniciAdi = data[KULLANICIADI] as? String ?? ""
                    let categoryName = data[CATEGORYNAME] as? String ?? ""
                    let fikirText = data[FIKIRTEXT] as? String ?? ""
                    let begeniSayisi = data[BEGENISAYISI] as? Int ?? -1
                    let yorumSayisi = data[YORUMSAYISI] as? Int ?? -1
                    let serverDate = data[EKLENMETARIHI] as? Timestamp ?? Timestamp()
                    let eklenmeTarihi = serverDate.dateValue()
                    let newFikir = Fikir(kullaniciAdi: kullaniciAdi, fikirText: fikirText, categoryName: categoryName, eklenmeTarihi: eklenmeTarihi, begeniSayisi: begeniSayisi, yorumSayisi: yorumSayisi)
                    print(newFikir.fikirText)
                    self.fikirArray.append(newFikir)
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeScreenViewController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fikirArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fikir = fikirArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FikirTableViewCell {
            cell.kullaniciAdiLabel.text = fikir.kullaniciAdi
            cell.begeniImageView.image = UIImage(systemName: "star")
            cell.fikirTextLabel.text = fikir.fikirText
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}

