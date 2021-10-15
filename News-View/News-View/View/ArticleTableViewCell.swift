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
    
    private let numberOfCharactersOnFourLines: Int = 109
    
    private var fullText: NSAttributedString?
    
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
    
    private let newsImageView: UIImageView = {
        let newsImageView = UIImageView()
        newsImageView.backgroundColor = .darkGray
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.layer.cornerRadius = 30
        newsImageView.clipsToBounds = true
        return newsImageView
    }()
    
    private let content: UILabel = {
        let content = UILabel()
        content.textColor = .green
        content.sizeToFit()
        content.numberOfLines = 4
        content.lineBreakMode = .byWordWrapping
        content.translatesAutoresizingMaskIntoConstraints = false
        content.isUserInteractionEnabled = true
        return content
    }()
    
    private let favourite: UILabel = {
        let favourite = UILabel()
        favourite.text = "🤍"
        favourite.sizeToFit()
        favourite.translatesAutoresizingMaskIntoConstraints = false
        favourite.isUserInteractionEnabled = true
        return favourite
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_:)))
        content.addGestureRecognizer(tapGesture)
        contentView.addSubview(favourite)
        contentView.addSubview(title)
        contentView.addSubview(author)
        contentView.addSubview(publishedAt)
        contentView.addSubview(newsImageView)
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            favourite.topAnchor
                .constraint(equalTo: contentView.topAnchor),
            favourite.rightAnchor
                .constraint(equalTo: contentView.rightAnchor),
            
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
            
            newsImageView.topAnchor
                .constraint(equalTo: publishedAt.bottomAnchor),
            newsImageView.centerXAnchor
                .constraint(equalTo: contentView.centerXAnchor),
            newsImageView.leftAnchor
                .constraint(equalTo: contentView.leftAnchor),
            newsImageView.rightAnchor
                .constraint(equalTo: contentView.rightAnchor),
            newsImageView.heightAnchor
                .constraint(equalToConstant: 300),
            
            content.topAnchor
                .constraint(equalTo: newsImageView.bottomAnchor),
            content.leftAnchor
                .constraint(equalTo: contentView.leftAnchor),
            content.rightAnchor
                .constraint(equalTo: contentView.rightAnchor),
            content.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate(delegate: ArticleTableViewCellDelegate) {
        self.delegate = delegate
    }
    
    func addToFavourites() {
        if favourite.text == "❤️" {
            favourite.text = "🤍"
        } else {
        favourite.text = "❤️"
        }
    }
    
    @objc private func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = content.text else { return }
        let readmoreRange = (text as NSString).range(of: "...Readmore")
        if gesture.didTapAttributedTextInLabel(cell: self, label: content, inRange: readmoreRange) {
            content.numberOfLines = 0
            content.attributedText = fullText
            delegate?.updateTableView()
        }
    }
    
    private func configureContent(newsDescription: String) {
        let truncatedDescription = "Description:\n\(newsDescription.prefix(90))"
        let description = NSMutableAttributedString(string: truncatedDescription, attributes: myAttribute)
        fullText = NSAttributedString(string: "Description:\n\(newsDescription)", attributes: myAttribute)
        content.attributedText = description
        
        if fullText!.length >= numberOfCharactersOnFourLines {
            DispatchQueue.main.async {
                self.content.addTrailing(with: "", moreText: "...Readmore", moreTextFont: UIFont(name: "Chalkduster", size: 15.0)!, moreTextColor: .cyan)
            }
        }
    }
    
    func configure(with newsModel: ArticleViewModel) {
        title.attributedText = NSAttributedString(string: "Title: \n\(newsModel.title)", attributes: myAttribute)
        author.attributedText = NSAttributedString(string: "Author: \n\(newsModel.author ?? "Unknown")", attributes: myAttribute)
        publishedAt.attributedText = NSAttributedString(string: "Published at: \n\(newsModel.publishedAt.components(separatedBy: "T")[0])", attributes: myAttribute)
        newsImageView.image = newsModel.image
        configureContent(newsDescription: newsModel.description)
    }
}


