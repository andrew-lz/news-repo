//
//  UICollectionViewFlowLayoutExt.swift
//  News-View
//
//  Created by BMF on 7.12.22.
//


import UIKit

extension UICollectionViewFlowLayout {
    func setItemSize(sectionsQuantity: Int, itemsQuantity: Int) {
            itemSize = CGSize(width: UIScreen.main.bounds.width / CGFloat(itemsQuantity), height: UIScreen.main.bounds.height / CGFloat(sectionsQuantity) - 2)
            minimumInteritemSpacing = 0
            self.invalidateLayout()
    }
}
