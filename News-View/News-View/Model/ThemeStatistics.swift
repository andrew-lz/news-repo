//
//  ThemeAnalyze.swift
//  News-View
//
//  Created by BMF on 5.12.22.
//

import Foundation

class ThemeStatistics {
    private(set) var theme: String
    private(set) var articleAnalyze: [(Int, Int)]

    init(theme: String, articleAnalyze: [(Int, Int)]) {
        self.theme = theme
        self.articleAnalyze = articleAnalyze
    }
}
