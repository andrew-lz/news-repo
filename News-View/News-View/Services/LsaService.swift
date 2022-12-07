//
//  LsaService.swift
//  News-View
//
//  Created by BMF on 5.12.22.
//

import Foundation

class LsaService {
    var articles: [Article] = []

    func analyzeArticles(with themes: [String]) -> [ThemeStatistics] {
        let themees = ["PS5", "Twitter", "Linux", "PlayStation", "Black Friday", "Friday"]
        //         Theme, articleIndex
        var themesStatistics = [ThemeStatistics]()

        for theme in themees {
            let themeIndexes = articles.enumerated()
                .filter({ _, article in

                    let articleDescription = article.description ?? "No description"
                    let descriptionMatch = articleDescription.range(of: theme, options: NSString.CompareOptions.caseInsensitive)
                    return descriptionMatch != nil
                })
                .map({ ($0.offset, $0.element.description?.countInstances(of: theme) ?? 0) })
            themesStatistics.append(ThemeStatistics(theme: theme, articleAnalyze: themeIndexes))
        }
        return themesStatistics
    }

//    func analyzeArticles(with themes: [String]) {
//        // [Theme, [(elementOffset, tfIdfs)]]
//        var tfIdfs = [(String, [(Int, Double)])]()
//        let themesStatistics = findThemesStatistics(with: themes)
//        for theme in themesStatistics {
//            var tfIdfForTheme = [(Int, Double)]()
//            for el in theme.1 {
//                let tfIdf =  Double(el.1) * log(Double(articles.count / theme.1.count))
//                tfIdfForTheme.append((el.0, tfIdf))
//            }
//            tfIdfs.append((theme.0, tfIdfForTheme))
//        }
//
//        for statistics in themesStatistics {
//            print(statistics)
//        }
//
//        print()
//
//        for tfIdf in tfIdfs {
//            print(tfIdf)
//        }
//    }
}
