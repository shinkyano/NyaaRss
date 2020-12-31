//
//  Item.swift
//  NyaaRSS
//
//  Created by Hervé PIERRE on 27/12/2020.
//

import Foundation

struct Item {
    var title: String {
        didSet {
            title = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    var category: String {
        didSet {
            category = category.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var size: String {
        didSet {
            size = size.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var link: String {
        didSet {
            link = link.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var guid: String {
        didSet {
            guid = guid.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var pubDate: String {
        didSet {
            pubDate = pubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var seeders: String {
        didSet {
            seeders = seeders.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var leechers: String {
        didSet {
            leechers = leechers.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var downloads: String {
        didSet {
            downloads = downloads.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var infoHash: String {
        didSet {
            infoHash = infoHash.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
}
