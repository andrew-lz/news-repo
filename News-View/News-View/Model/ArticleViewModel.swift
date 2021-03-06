//
//  ArticleViewModel.swift
//  News-View
//
//  Created by BMF on 2.09.21.
//

import Foundation
import UIKit

struct ArticleViewModel {
    let title: String
    let author: String?
    let description: String
    let image: UIImage
    let publishedAt: String
    let isLiked: Bool
}
