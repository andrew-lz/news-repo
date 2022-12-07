//
//  CustomCollectionViewCell.swift
//  News-View
//
//  Created by BMF on 5.12.22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CustomCollectionViewCell"

    private let tfIdfOfArticleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tfIdfOfArticleLabel)
        NSLayoutConstraint.activate([
            tfIdfOfArticleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tfIdfOfArticleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tfIdfOfArticleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
        ])
        backgroundColor = .black
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String) {
        tfIdfOfArticleLabel.text = text
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tfIdfOfArticleLabel.text = ""
    }
}