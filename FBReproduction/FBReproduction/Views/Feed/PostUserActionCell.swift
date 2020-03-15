//
//  Fd_PostUserActionCell.swift
//  dk236
//
//  Created by Nguyen Khac Dai on 12/2/19.
//  Copyright © 2019 dk236. All rights reserved.
//

import UIKit
//import Action
class PostUserActionCell: UICollectionViewCell {
  static let inset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
  static func cellSize(width: CGFloat) -> CGSize {
    return CGSize(width: width, height: 44)
  }
//  private var likeAction: Action<LikeButton, Void>?
  private(set) var likeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.titleLabel?.font = Font.systemRegularFont(ofSize: 12)
    button.setTitleColor(.darkGray, for: .normal)
    button.setImage(UIImage(named: "feed.action.like-normal"), for: .normal)
    button.centerTextAndImage(spacing: 10)
    button.setTitle("0", for: .normal)
    return button
  }()
  
  private(set) var commentButton: UIButton = {
    let button = UIButton(type: .custom)
    button.titleLabel?.font = Font.systemRegularFont(ofSize: 12)
    button.setTitleColor(.darkGray, for: .normal)
    button.setImage(UIImage(named: "feed.action.comment-normal"), for: .normal)
    button.centerTextAndImage(spacing: 10)
    button.setTitle("0", for: .normal)
    return button
  }()
  
  private(set) var shareButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "feed.action.share-normal"), for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(likeButton)
    contentView.addSubview(commentButton)
    contentView.addSubview(shareButton)
    contentView.clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    reloadViewLayout()
    shareButton.frame = CGRect(x: bounds.width - (20 + 15), y: 0, width: 20, height: bounds.height)
  }
  
  private func reloadViewLayout() {
    likeButton.sizeToFit()
    commentButton.sizeToFit()
    likeButton.frame = CGRect(x: 14, y: 0, width: max(40, likeButton.frame.width), height: bounds.height)
    commentButton.frame = CGRect(x: 87, y: 0, width: max(40, commentButton.frame.width), height: bounds.height)
  }
  
  func configure(_ model: FeedUserActionContent) {
    likeButton.setTitle("\(model.likeNumber)", for: .normal)
    commentButton.setTitle("\(model.commentNumber)", for: .normal)
    reloadViewLayout()
  }
  
}
