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
    
    @IBOutlet weak var segmentedCategoryOut: UISegmentedControl!
    private var dbListener : CollectionReference!
    private var fikirArray = [Fikir]()
    private var fikirlerListener : ListenerRegistration!
    private var selectedCategory : String = "Gündem"
    
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
            fikirlerListener = dbListener.whereField(CATEGORYNAME, isEqualTo: selectedCategory).order(by: EKLENMETARIHI, descending: true)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        fikirlerListener.remove()
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
    
}

extension HomeScreenViewController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fikirArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fikir = fikirArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FikirTableViewCell {
            cell.gorunumAyarla(fikir: fikir)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}

