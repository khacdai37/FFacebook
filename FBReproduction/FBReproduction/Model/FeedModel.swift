//
//  FeedModel.swift
//  dk236
//
//  Created by Nguyen Khac Dai on 12/11/19.
//  Copyright © 2019 dk236. All rights reserved.
//

import Foundation
struct ImageItem {
  var urlString: String
  var width: CGFloat?
  var height: CGFloat?
  var url: URL? {
    return URL(string: urlString)
  }
}
struct PostCategory {
  var id: Int
  var name: String
  var descriptions: String?
  init(id: Int, name: String, description: String? = nil) {
    self.id = id
    self.name = name
    self.descriptions = description
  }
}

class PostItem {
  var id: Int
  var author: UserRepresentable
  var createdAt: String
  var content: String?
  var images: [ImageItem]?
  var imageMax: Int
  var likeNumber: Int
  var commentNumber: Int
  var likedByMe: Bool
  var postType: PostCategory
  
  init(id: Int,
       author: UserRepresentable,
       createdAt: String,
       content: String?,
       images: [ImageItem]?,
       imageMax: Int,
       likeNumber: Int,
       commentNumber: Int,
       likedByMe: Bool,
       postType: PostCategory) {
    self.id = id
    self.author = author
    self.createdAt = createdAt
    self.content = content
    self.images = images
    self.imageMax = imageMax
    self.likeNumber = likeNumber
    self.commentNumber = commentNumber
    self.likedByMe = likedByMe
    self.postType = postType
  }
  
  init(id: Int) {
    self.id = id
    self.author = User(id: 0, name: "", avatarURL: "")
    self.createdAt = ""
    self.content = ""
    self.images = []
    self.imageMax = 0
    self.likeNumber = 0
    self.commentNumber = 0
    self.likedByMe = false
    self.postType = PostCategory(id: -1, name: "empty")
  }
}

class UserFeedItem: NSObject {
  var id: Int
  private var personalInfo: FeedPersonalInfoContent
  private var textContent: FeedTextContent
  private var imageContent: FeedPostImagesContent?
  private var userActionContent: FeedUserActionContent
  private(set) var items: [FeedContentProtocol]
  init(post: PostItem) {
    id = post.id
    personalInfo = FeedPersonalInfoContent(user: post.author, postShortInfo: "\(post.createdAt)")
    if let postContent = post.content {
      textContent = FeedTextContent(text: postContent)
    }else {
      textContent = FeedTextContent()
    }
    userActionContent = FeedUserActionContent(likeNumber: post.likeNumber, commentNumber: post.commentNumber, likeByMe: post.likedByMe)
    items = [personalInfo, textContent, userActionContent]
    super.init()
  }
 
  
}

//MARK: - Feed
protocol FeedContentProtocol {
  func expectContentSizeWith(width: CGFloat) -> CGSize
}
extension FeedContentProtocol {
  func expectContentSizeWith(width: CGFloat) -> CGSize {
    return .zero
  }
}
class FeedTextContent: FeedContentProtocol {
  private var fullText: NSAttributedString?
  private var shortText: NSAttributedString?
  var isCollapsed = true
  init(text: String) {
    self.fullText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : Font.systemRegularFont()])
    self.shortText = FeedTextContent.createShortText(from: text) ?? self.fullText
  }
  init() {}
  var content: NSAttributedString? {
    if isCollapsed {
      return shortText
    }
    return fullText
  }
  func expectContentSizeWith(width: CGFloat) -> CGSize {
    guard let content = content else {
      return .zero
    }
    return TextSize.sizeCache(content, width: width, insets: PostTextContentCell.inset).size
  }
  
  static func createShortText(from text: String) -> NSAttributedString? {
    var vissibleTextLength: Int {
      let mode: NSLineBreakMode =  .byTruncatingTail
      let labelWidth: CGFloat = UIScreen.main.bounds.width - PostTextContentCell.inset.left - PostTextContentCell.inset.right
      let labelHeight: CGFloat = PostTextContentCell.font.lineHeight * 3
      let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
      
      let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: PostTextContentCell.font]
      let attributedText = NSAttributedString(string: text, attributes: attributes as? [NSAttributedString.Key : Any])
      let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
      
      if boundingRect.size.height > labelHeight {
        var index: Int = 0
        var prev: Int = 0
        let characterSet = CharacterSet.whitespacesAndNewlines
        repeat {
          prev = index
          if mode == NSLineBreakMode.byCharWrapping {
            index += 1
          } else {
            index = (text as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: text.count - index - 1)).location
          }
        } while index != NSNotFound && index < text.count && (text as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
        return prev
      }
      return text.count
    }
    let trailingText = "..."
    let moreText = "feed.title.read-more".localized()
    let readMoreText: String = trailingText + moreText
    let readMoreLength: Int = readMoreText.count
    guard text.count > readMoreLength else {
      return nil
    }
    let lengthForVisibleString: Int = vissibleTextLength
    guard text.count > lengthForVisibleString else {
      return nil
    }
    
    let trimmedNSRange = NSRange(location: lengthForVisibleString, length: (text.count - lengthForVisibleString))
    guard let trimmedRange = Range(trimmedNSRange, in: text) else {
      return nil
    }
    let trimmedString = text.replacingCharacters(in: trimmedRange, with: "")
    var trimmedForReadMore = trimmedString
    if let readMoreRange = Range(NSRange(location: trimmedString.count - readMoreLength, length: readMoreLength), in: trimmedString) {
      trimmedForReadMore = trimmedString.replacingCharacters(in: readMoreRange, with: "")
    }
    
    trimmedForReadMore += trailingText
    let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: PostTextContentCell.font])
    let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: PostTextContentCell.font, NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    answerAttributed.append(readMoreAttributed)
    return answerAttributed
  }
  
  
}

struct FeedPersonalInfoContent: FeedContentProtocol {
  var user: UserRepresentable
  var postShortInfo: String
  
  func expectContentSizeWith(width: CGFloat) -> CGSize {
    return CGSize(width: width, height: 54)
  }
}


class FeedPostImagesContent: NSObject, FeedContentProtocol {
  var images: [UIImage]
  var max: Int
  init(images: [UIImage], max: Int) {
    self.images = images
    self.max = max
  }
  func expectContentSizeWith(width: CGFloat) -> CGSize {
    let imageNumber = images.count
    let heightSizes: [Int: CGFloat] = [1: 240, 2: 190]
    return CGSize(width: width, height: heightSizes[imageNumber] ?? 384)
  }
  
}

struct FeedPostImageContent: FeedContentProtocol {
  var image: UIImage
  func expectContentSizeWith(width: CGFloat) -> CGSize {
    //    let ratio = (image.height ?? 0) / (image.width ?? 1)
    //    let height = width * ratio
    //    return CGSize(width: width, height: height == 0 ? 200 : height)
    return .init(width: 200, height: 200)
  }
}


class FeedUserActionContent: NSObject, FeedContentProtocol {
  var likeNumber: Int
  var commentNumber: Int
  var likedByMe: Bool
  init(likeNumber: Int, commentNumber: Int, likeByMe: Bool) {
    self.likeNumber = likeNumber
    self.commentNumber = commentNumber
    self.likedByMe = likeByMe
  }
  func expectContentSizeWith(width: CGFloat) -> CGSize {
    return CGSize(width: width, height: 44)
  }
  
}


//MARK: - Writing Post
