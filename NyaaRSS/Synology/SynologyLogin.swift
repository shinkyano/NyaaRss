//
//  SynologyLogin.swift
//  NyaaRSS
//
//  Created by Hervé PIERRE on 31/12/2020.
//

import Foundation

// MARK: - Welcome
struct SynologyLogin: Codable {
    let data: DataClass
    let success: Bool
}

// MARK: - DataClass
struct DataClass: Codable {
    let isPortalPort: Bool
    let sid: String

    enum CodingKeys: String, CodingKey {
        case isPortalPort = "is_portal_port"
        case sid
    }
}
