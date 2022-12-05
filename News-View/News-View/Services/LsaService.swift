//
//  LsaService.swift
//  News-View
//
//  Created by BMF on 5.12.22.
//

import Foundation

class LsaService {
    var articles: [Article] = []

    private func findThemesStatistics(with themes: [String]) -> [(String, [(Int, Int)])] {
        let themees = ["PS5", "Twitter", "Linux", "PlayStation", "Black Friday"]
        //         Theme, articleIndex
        var analyzedTable = [(String, [(Int, Int)])]()

        for theme in themees {
            let themeIndexes = articles.enumerated()
                .filter({ _, article in

                    let articleDescription = article.description ?? "No description"
                    let descriptionMatch = articleDescription.range(of: theme, options: NSString.CompareOptions.caseInsensitive)
                    return descriptionMatch != nil
                })
                .map({ ($0.offset, $0.element.description?.countInstances(of: theme) ?? 0) })
            analyzedTable.append((theme, themeIndexes))
        }
        return analyzedTable
    }

    func analyzeArticles(with themes: [String]) {
        // [Theme, [(elementOffset, tfIdfs)]]
        var tfIdfs = [(String, [(Int, Double)])]()
        let themesStatistics = findThemesStatistics(with: themes)
        for theme in themesStatistics {
            var tfIdfForTheme = [(Int, Double)]()
            for el in theme.1 {
                let tfIdf =  Double(el.1) * log(Double(articles.count / theme.1.count))
                tfIdfForTheme.append((el.0, tfIdf))
            }
            tfIdfs.append((theme.0, tfIdfForTheme))
        }

        for statistics in themesStatistics {
            print(statistics)
        }

        print()

        for tfIdf in tfIdfs {
            print(tfIdf)
        }
    }
}
