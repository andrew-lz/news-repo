//
//  LsaTableViewController.swift
//  News-View
//
//  Created by BMF on 5.12.22.
//

import UIKit

class LsaTableViewController : UICollectionViewController {

    private var themesStatistics: [ThemeStatistics] = []

    private var themeStatisticsPoints = [(Int, Int)]()

    private var tableMatrix: [ThemeStatistics] = []

    private var articlesNumbers = [Int]()

    private var currentThemeIndex = 0

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    convenience init(themesStatistics: [ThemeStatistics]) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.themesStatistics = themesStatistics
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fillTableMatrix()

        (collectionViewLayout as? UICollectionViewFlowLayout)?.setItemSize(sectionsQuantity: themesStatistics.count + 1, itemsQuantity: articlesNumbers.count + 1)

        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)

        collectionView.backgroundColor = .black
    }

    private func fillArticlesNumbersAsc() {
        articlesNumbers = Array(Set(themesStatistics.flatMap { themeStat in
            themeStat.articleAnalyze.map { $0.0 }
        })).sorted(by: <)
    }

    private func fillTableMatrix() {
        fillArticlesNumbersAsc()
        print(articlesNumbers)
        tableMatrix = themesStatistics.map({ themeStatistics in
            themeStatisticsPoints = []
            for articleNumber in articlesNumbers {
                if themeStatistics.articleAnalyze.contains(where: { $0.0 == articleNumber }) {
                    themeStatisticsPoints += themeStatistics.articleAnalyze
                } else {
                    themeStatisticsPoints += [(0, 0)]
                }
            }
            print(themeStatisticsPoints)
            print()
            return ThemeStatistics(theme: themeStatistics.theme, articleAnalyze: themeStatisticsPoints)
        })
    }
}
extension LsaTableViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return themesStatistics.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesNumbers.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.configure(with: "")
            } else {
                let currentPoint = articlesNumbers[indexPath.row - 1]
                cell.configure(with: "\(currentPoint)")
            }
        }
        else if indexPath.row == 0 {
            cell.configure(with: themesStatistics[currentThemeIndex].theme)
            currentThemeIndex += 1
        }
        else {
            let currentPoint = tableMatrix[indexPath.section - 1].articleAnalyze[indexPath.row - 1]
            cell.configure(with: "\(currentPoint.1)")
        }
        return cell
    }
}
extension LsaTableViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item row \(indexPath.row) section \(indexPath.section)")
    }
}
