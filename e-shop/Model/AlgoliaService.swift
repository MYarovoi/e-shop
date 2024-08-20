//
//  AlgoliaService.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 20.08.2024.
//

import Foundation
import AlgoliaSearchClient

class AlgoliaService {
    

    static let shared = AlgoliaService()

    private lazy var client: SearchClient = {
        SearchClient(appID: "PHUKW35N93", apiKey: "86e3d3aa4f7e0cd01b6b94c42c96ba42")
    }()

    lazy var index: Index = {
        client.index(withName: "item_name")
    }()

    private init() {
    }
}
