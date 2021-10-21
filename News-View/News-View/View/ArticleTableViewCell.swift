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
        return title
    }()
    private let author: UILabel = {
        let author = UILabel()
        author.textColor = .cyan
        author.numberOfLines = 0
        return author
    }()
    private let publishedAt: UILabel = {
        let publishedAt = UILabel()
        publishedAt.textColor = .magenta
        publishedAt.numberOfLines = 0
        return publishedAt
    }()
    private let newsImageView: UIImageView = {
        let newsImageView = UIImageView()
        newsImageView.backgroundColor = .darkGray
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
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
        content.isUserInteractionEnabled = true
        return content
    }()
    private let likeLabel: UILabel = {
        var like = UILabel()
        like.translatesAutoresizingMaskIntoConstraints = false
        like.text = "❤️"
        like.font = like.font.withSize(70)
        like.textAlignment = .center
        like.isHidden = true
        return like
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = true
        stack.axis = .vertical
        return stack
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addReadmoreGestureRecognizer()
        addLikeGestureRecognizer()
        setupStackView()
        setupLikeLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setDelegate(delegate: ArticleTableViewCellDelegate) {
        self.delegate = delegate
    }
    private func setupStackView() {
        let stackSubviews = [title, author, publishedAt, newsImageView, content]
        stackSubviews.forEach { stackSubview in
            stackView.addArrangedSubview(stackSubview)
            addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leftAnchor.constraint(equalTo: leftAnchor),
                stackView.rightAnchor.constraint(equalTo: rightAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
    private func addReadmoreGestureRecognizer() {
        let tapReadmoreGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_:)))
        tapReadmoreGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapReadmoreGesture)
    }
    private func addLikeGestureRecognizer() {
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnCell(_:)))
        likeTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(likeTapGesture)
    }
    private func setupLikeLabel() {
        addSubview(likeLabel)
        NSLayoutConstraint.activate([
            likeLabel.centerXAnchor.constraint(equalTo: newsImageView.centerXAnchor),
            likeLabel.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor)
        ])
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
                self.content.addTrailing(with: "", moreText: "...Readmore",
                                         moreTextFont: UIFont(name: "Chalkduster", size: 15.0)!, moreTextColor: .cyan)
            }
        }
    }
    func configure(with newsModel: ArticleViewModel) {
        title.attributedText = NSAttributedString(string: "Title: \n\(newsModel.title)", attributes: myAttribute)
        author.attributedText = NSAttributedString(string: "Author: \n\(newsModel.author ?? "Unknown")",
                                                   attributes: myAttribute)
        publishedAt.attributedText =
            NSAttributedString(string: "Published at: \n\(newsModel.publishedAt.components(separatedBy: "T")[0])",
                               attributes: myAttribute)
        newsImageView.image = newsModel.image
        configureContent(newsDescription: newsModel.description)
    }
    @objc private func didTapOnCell(_ gesture: UITapGestureRecognizer) {
        likeLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.likeLabel.isHidden = true
        }
    }
    override func prepareForReuse() {
        likeLabel.isHidden = true
    }
}
