//
//  YorumViewController.swift
//  Cakma Sozluk
//
//  Created by Aytaç Bulanık on 3.11.2024.
//

import UIKit

class YorumViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yorumField: UITextField!
    
    var secilenFikir : Fikir!
    var yorumArray = [Yorum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    

   
    @IBAction func yorumSendButtonPressed(_ sender: UIButton) {
        
        
    }
    
}

extension YorumViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yorumArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "yorumCell", for: indexPath) as? YorumTableViewCell {
            let gecerliYorum = yorumArray[indexPath.row]
            cell.gorunumAyarla(yorum: gecerliYorum)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
