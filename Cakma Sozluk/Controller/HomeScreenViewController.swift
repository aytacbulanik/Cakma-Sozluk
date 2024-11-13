    //
    //  HomeScreenViewController.swift
    //  Cakma Sozluk
    //
    //  Created by Aytaç Bulanık on 30.10.2024.
    //

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedCategoryOut: UISegmentedControl!
    private var dbListener : CollectionReference!
    private var fikirArray = [Fikir]()
    private var fikirlerListener : ListenerRegistration!
    private var selectedCategory : String = "Gündem"
    private var userHandle : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dbListener = Firestore.firestore().collection(FIKIRLER)
        title = Auth.auth().currentUser?.displayName?.uppercased()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userHandle = Auth.auth().addStateDidChangeListener({ auth, user in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "girisYap")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                DispatchQueue.main.async {
                    self.getFikir()
                }
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if fikirlerListener != nil {
            fikirlerListener.remove()
        }
        
    }
    
    func getFikir() {
        if selectedCategory == "Popüler" {
            fikirlerListener = dbListener.order(by: EKLENMETARIHI, descending: true)
                .addSnapshotListener{ (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else {
                        self.fikirArray.removeAll(keepingCapacity: true)
                        self.fikirArray = Fikir.getFikir(snapShot: querySnapshot)
                        self.tableView.reloadData()
                    }
                }
        } else {
            fikirlerListener = dbListener
                .whereField(CATEGORYNAME, isEqualTo: selectedCategory)
                .order(by: EKLENMETARIHI, descending: true)
                .addSnapshotListener{ (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error.localizedDescription)")
                    } else {
                        self.fikirArray.removeAll(keepingCapacity: true)
                        self.fikirArray = Fikir.getFikir(snapShot: querySnapshot)
                        self.tableView.reloadData()
                    }
                }
        }
        
    }
    
    
    
    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedCategory = "Gündem"
        case 1: selectedCategory = "Siyaset"
        case 2: selectedCategory = "Magazin"
        case 3: selectedCategory = "Spor"
        case 4: selectedCategory = "Popüler"
        default : selectedCategory = "Gündem"
        }
        fikirlerListener.remove()
        getFikir()
    }
    
    @IBAction func cikisYapButtonPressed(_ sender: UIBarButtonItem) {
        
        let currentUser = Auth.auth()
        do {
            try currentUser.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yorumSegue" {
            if let hedefVC = segue.destination as? YorumViewController {
                if let gidenFikir = sender as? Fikir {
                    hedefVC.secilenFikir = gidenFikir
                }
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
            cell.gorunumAyarla(fikir: fikir , delegate: self)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gidenFikir = fikirArray[indexPath.row]
        performSegue(withIdentifier: "yorumSegue", sender: gidenFikir)
    }
    
    
}

extension HomeScreenViewController : FikirDelegate  {
    func seceneklerFikirDelegate(fikir: Fikir) {
        let alert = UIAlertController(title: "Fikri Silmek istiyor musunuz?", message: nil, preferredStyle: .actionSheet)
        
        let silAction = UIAlertAction(title: "Fikri Sil", style: .default) { action in
            let yorumlarCollRef = Firestore.firestore().collection(FIKIRLER).document(fikir.documentId).collection(YORUMLAR)
            let begenilerCollRef = Firestore.firestore().collection(FIKIRLER).document(fikir.documentId).collection(BEGENILER)
            self.tumAltCollectionSil(collection: begenilerCollRef) { error in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    self.tumAltCollectionSil(collection: yorumlarCollRef) { (hata) in
                        if let hata = hata {
                            debugPrint("tüm yorumları silerken hata oluştu : \(hata.localizedDescription)")
                        }else {
                            Firestore.firestore().collection(FIKIRLER).document(fikir.documentId).delete { (hata) in
                                if let hata = hata {
                                    debugPrint("bu fikri silerken hata oluştu : \(hata.localizedDescription)")
                                }else {
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
        
        let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
        alert.addAction(silAction)
        alert.addAction(iptalAction)
        
        self.present(alert, animated: true)
    }
    
    func tumAltCollectionSil(collection : CollectionReference , silinecekKayitSayisi : Int = 100 , completion : @escaping (Error?) -> ()) {
        
        collection.limit(to: silinecekKayitSayisi).getDocuments(completion: {(kayitSetleri , hata) in
            guard let kayitSetleri = kayitSetleri else {
                completion(hata)
                return
            }
            guard kayitSetleri.count > 0 else {
                completion(nil)
                return
            }
            let batch = collection.firestore.batch() //birden fazla write işlemi yapmak için bunu kullancağız.
            kayitSetleri.documents.forEach { batch.deleteDocument($0.reference)
            }
            batch.commit { batchHata in
                if let hata = batchHata {
                    completion(hata)
                } else {
                    self.tumAltCollectionSil(collection: collection, silinecekKayitSayisi: silinecekKayitSayisi, completion: completion)
                }
            }
        })
    }
    
}

