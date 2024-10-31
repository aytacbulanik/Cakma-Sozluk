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
    
    private var dbListener : CollectionReference!
    private var fikirArray = [Fikir]()
    private var fikirlerListener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dbListener = Firestore.firestore().collection(FIKIRLER)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.getFikir()
        }
    }
    
    func getFikir() {
        fikirlerListener = dbListener.addSnapshotListener{ (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                self.fikirArray.removeAll(keepingCapacity: true)
                guard let snap = querySnapshot else { return }
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
                    let newFikir = Fikir(kullaniciAdi: kullaniciAdi, fikirText: fikirText, categoryName: categoryName, eklenmeTarihi: eklenmeTarihi, begeniSayisi: begeniSayisi, yorumSayisi: yorumSayisi , documentId: documentID)
                    self.fikirArray.append(newFikir)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fikirlerListener.remove()
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
            cell.begeniSayisiLabel.text = String(fikir.begeniSayisi)
            cell.eklenmeTarihiLabel.text = showTarih(zaman: fikir.eklenmeTarihi)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func showTarih(zaman : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY - HH:mm"
        return formatter.string(from: zaman)
    }
}

