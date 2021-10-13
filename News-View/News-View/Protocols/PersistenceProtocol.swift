//
//  PersistenceProtocol.swift
//  News-View
//
//  Created by Lazerko, Andrey on 13.10.21.
//

import Foundation

protocol PersistenceProtocol {
    func save(article: Article)
    func delete(article: Article)
    func getAllData()
}
