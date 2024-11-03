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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func yorumSendButtonPressed(_ sender: UIButton) {
        
        
    }
    
}
