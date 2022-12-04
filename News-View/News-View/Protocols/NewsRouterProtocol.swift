//
//  NewsRouterProtocol.swift
//  News-View
//
//  Created by Lazerko, Andrey on 13.10.21.
//

protocol NewsRouterProtocol {
    func makeViewController(with topic: String) -> ViewController
}
