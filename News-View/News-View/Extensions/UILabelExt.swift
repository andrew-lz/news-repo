//
//  UILabelExt.swift
//  News-View
//
//  Created by BMF on 8.09.21.
//

import Foundation
import UIKit

extension UILabel {
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        if self.visibleTextLength == 0 { return }
        let lengthForVisibleString: Int = self.visibleTextLength
        if let myText = text {
            let mutableString: String = myText
            let trimmedString: String? = (mutableString as NSString)
                .replacingCharacters(in: NSRange(location: lengthForVisibleString,
                                                 length: myText.count - lengthForVisibleString), with: "")
            let readMoreLength: Int = (readMoreText.count)
            guard let safeTrimmedString = trimmedString else { return }
            if safeTrimmedString.count <= readMoreLength { return }
            let trimmedForReadMore: String = (safeTrimmedString as NSString)
                .replacingCharacters(in: NSRange(location: safeTrimmedString.count - readMoreLength,
                                                 length: readMoreLength), with: "") + trailingText
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore,
                                                             attributes: [NSAttributedString.Key.font: font as Any])
            let attributes = [NSAttributedString.Key.font: moreTextFont,
                              NSAttributedString.Key.foregroundColor: moreTextColor]
            let readMoreAttributed = NSMutableAttributedString(string: moreText,
                                                               attributes: attributes)
            answerAttributed.append(readMoreAttributed)
            attributedText = answerAttributed
        }
    }
    private var visibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = lineBreakMode
        let labelWidth: CGFloat = frame.size.width
        let labelHeight: CGFloat = frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        if let myText = text {
            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: myText,
                                                    attributes: attributes as? [NSAttributedString.Key: Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint,
                                                                   options: .usesLineFragmentOrigin, context: nil)
            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (myText as NSString)
                            .rangeOfCharacter(from: characterSet,
                                              options: [],
                                              range: NSRange(location: index + 1,
                                                             length: myText.count - index - 1)).location
                    }
                } while index != NSNotFound && index < myText.count && (myText as NSString)
                    .substring(to: index).boundingRect(with: sizeConstraint,
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: attributes as? [NSAttributedString.Key: Any],
                                                       context: nil).size.height <= labelHeight
                return prev
            }
        }
        if text == nil {
            return 0
        } else {
            return text!.count
        }
    }
}
