//
//  DetailViewController.swift
//  NyaaRSS
//
//  Created by Hervé PIERRE on 26/12/2020.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var titleValue: String = ""
    var categoryValue: String = ""
    var sizeValue: String = ""
    var torrentLinkValue: String = ""
    
    let synologyManager: SynologyManager = SynologyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleValue
        categoryLabel.text = categoryValue
        sizeLabel.text = sizeValue
    }
    
    @IBAction func downloadPressed(_ sender: UIButton) {
        synologyManager.download(torrent: torrentLinkValue)
    }
    
}
