//
//  TableViewController.swift
//  NyaaRSS
//
//  Created by Hervé PIERRE on 25/12/2020.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {
    
    @IBOutlet var tableview: UITableView!
    
    var items: [Item] = []
    var elementName: String = ""
    var itemTitle: String = ""
    var itemCategory: String = ""
    
    var itemSize: String = ""
    var itemLink: String = ""
    var itemGuid: String = ""
    var itemPubDate: String = ""
    var itemSeeders: String = ""
    var itemLeechers: String = ""
    var itemDownloads: String = ""
    var itemInfoHash: String = ""
    
    var itemToSend: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.registerTableViewCells()
        
        let urlString = "https://nyaa.si/?page=rss"
        let url = URL(string: urlString)
        
        if let parser = XMLParser(contentsOf: url!) {
            parser.delegate = self
            parser.parse()
        }
    }
        
    // MARK: - Table view data source
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomCell",
                                  bundle: nil)
        self.tableview.register(textFieldCell,
                                forCellReuseIdentifier: "CustomCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell{
            
            let item = items[indexPath.row]
            cell.titre?.text = item.title
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemToSend = items[indexPath.row]
        
        self.performSegue(withIdentifier: "showItemDetails", sender: tableview)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemDetails" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.titleValue = itemToSend?.title ?? ""
            destinationVC.categoryValue = itemToSend?.category ?? ""
            destinationVC.sizeValue = itemToSend?.size ?? ""
            destinationVC.torrentLinkValue = itemToSend?.link ?? ""
//            print(segue.destination)
        }
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if self.elementName == "item" {
            itemTitle = String()
            itemCategory = String()
            itemSize  = String()
            itemLink  = String()
            itemGuid  = String()
            itemSeeders  = String()
            itemLeechers  = String()
            itemDownloads  = String()
            itemPubDate  = String()
            itemInfoHash  = String()
        }
        
        self.elementName = elementName
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let item  = Item(title: itemTitle, category: itemCategory, size: itemSize, link: itemLink, guid: itemGuid, pubDate: itemPubDate, seeders: itemSeeders, leechers: itemLeechers, downloads: itemDownloads, infoHash: itemInfoHash)
//            print(item.title)
            items.append(item)
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch self.elementName {
        case "title" :
            itemTitle += string
        case "nyaa:category" :
            itemCategory += string
        case "nyaa:size" :
            itemSize += string
        case "link" :
            itemLink += string
        case "guid" :
            itemGuid += string
        case "pubDate" :
            itemPubDate += string
        case "nyaa:seeders" :
            itemSeeders += string
        case "nyaa:leechers" :
            itemLeechers += string
        case "nyaa:downloads" :
            itemDownloads += string
        case "nyaa:infoHash" :
            itemInfoHash += string
        default:
            break
        }
                
    }
    
}
