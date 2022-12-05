//
//  CollectionViewLayout.swift
//  News-View
//
//  Created by BMF on 5.12.22.
//

import UIKit

class CollectionViewLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        super.prepare()
        if UIDevice.current.orientation.isPortrait {
            let widthHeightConstant = ((UIScreen.main.bounds.width - 2))
            self.itemSize = CGSize(width: widthHeightConstant,
                                   height: widthHeightConstant)
            self.minimumInteritemSpacing = 1
            self.minimumLineSpacing = 1
            self.scrollDirection = .vertical
            self.invalidateLayout()
        } else if UIDevice.current.orientation.isLandscape {
            let widthConstant = UIScreen.main.bounds.width / 3 - 1
            let heightConstant = UIScreen.main.bounds.height / 2 - 2
            self.itemSize = CGSize(width: widthConstant,
                                   height: heightConstant)
            self.minimumInteritemSpacing = 1
            self.minimumLineSpacing = 1
            self.scrollDirection = .vertical
            self.invalidateLayout()
        }
    }
}

