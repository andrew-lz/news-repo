//
//  NetworkProtocol.swift
//  News-View
//
//  Created by Lazerko, Andrey on 13.10.21.
//

import Foundation

protocol NetworkProtocol {
    func loadNewsPage(before daysQuantity: Int, then handler: @escaping ([Article]) -> Void)
    func loadImageFromUrl(stringUrl: String?) -> Data?
}
