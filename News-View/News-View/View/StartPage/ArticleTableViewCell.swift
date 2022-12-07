//
//  CustomTableViewCell.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import Foundation
import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    private weak var delegate: ArticleTableViewCellDelegate?
    
    static let identifier: String = "CustomCollectionViewCell"
    
    private let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 15.0)! ]
    
    private let title: UILabel = {
        let title = UILabel()
        title.textColor = .orange
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let author: UILabel = {
        let author = UILabel()
        author.textColor = .cyan
        author.numberOfLines = 0
        author.translatesAutoresizingMaskIntoConstraints = false
        return author
    }()
    
    private let publishedAt: UILabel = {
        let publishedAt = UILabel()
        publishedAt.textColor = .magenta
        publishedAt.numberOfLines = 0
        publishedAt.translatesAutoresizingMaskIntoConstraints = false
        return publishedAt
    }()
    
    private let content: UILabel = {
        let content = UILabel()
        content.textColor = .green
        content.sizeToFit()
        content.numberOfLines = 0
        content.lineBreakMode = .byWordWrapping
        content.translatesAutoresizingMaskIntoConstraints = false
        content.isUserInteractionEnabled = true
        return content
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [title, author, publishedAt, content].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            
            title.leftAnchor
                .constraint(equalTo: contentView.leftAnchor),
            title.rightAnchor
                .constraint(equalTo: contentView.rightAnchor),
            title.topAnchor
                .constraint(equalTo: contentView.topAnchor),
            
            author.rightAnchor
                .constraint(equalTo: contentView.rightAnchor),
            author.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            author.topAnchor
                .constraint(equalTo: title.bottomAnchor),
            
            publishedAt.leftAnchor
                .constraint(equalTo: contentView.leftAnchor),
            publishedAt.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            publishedAt.topAnchor
                .constraint(equalTo: author.bottomAnchor),
            
            content.topAnchor
                .constraint(equalTo: publishedAt.bottomAnchor),
            content.leftAnchor
                .constraint(equalTo: contentView.leftAnchor),
            content.rightAnchor
                .constraint(equalTo: contentView.rightAnchor),
            content.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor)
            
        ])
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate(delegate: ArticleTableViewCellDelegate) {
        self.delegate = delegate
    }
    
    private func configureContent(newsDescription: String) {
        let fullText = NSMutableAttributedString(string: "DESCRIPTION:\n\(newsDescription)", attributes: myAttribute)
        content.attributedText = fullText
    }
    
    func configure(with newsModel: ArticleViewModel) {
        title.attributedText = NSAttributedString(string: "TITLE: \n\(newsModel.title)", attributes: myAttribute)
        author.attributedText = NSAttributedString(string: "AUTHOR: \n\(newsModel.author ?? "Unknown")", attributes: myAttribute)
        publishedAt.attributedText = NSAttributedString(string: "PUBLISHED AT: \n\(newsModel.publishedAt.components(separatedBy: "T")[0])", attributes: myAttribute)
        configureContent(newsDescription: newsModel.description)
    }
    
    func getAllCellData() {
        print((title.text) ?? "Title")
        print(author.text ?? "Author")
        print(publishedAt.text ?? "PublishedAt")
        print(content.text ?? "Description")
    }
}


