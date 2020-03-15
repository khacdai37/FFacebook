//
//  Fd_PostUserCell.swift
//  dk236
//
//  Created by Nguyen Khac Dai on 12/2/19.
//  Copyright © 2019 dk236. All rights reserved.
//

import UIKit
import Kingfisher
//import Action
class PostPersonalInfoCell: UICollectionViewCell {
  static let inset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
  
  let userInforLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = Font.systemBoldFont(ofSize: 12)
    label.textColor = .black
    return label
  }()
  let timeLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = Font.systemRegularFont(ofSize: 11)
    label.textColor = .darkGray
    return label
  }()
  
  let avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private(set) var menuButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "btn_optional_menu"), for: .normal)
    button.contentVerticalAlignment = .top
    return button
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(userInforLabel)
    contentView.addSubview(avatarImageView)
    contentView.addSubview(timeLabel)
    contentView.addSubview(menuButton)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let inset = PostPersonalInfoCell.inset
    avatarImageView.frame = CGRect(x: inset.left, y: inset.top, width: bounds.height - inset.top * 2, height: bounds.height - inset.top * 2)
    userInforLabel.frame = CGRect(x: avatarImageView.frame.maxX + 8,
                                  y: avatarImageView.frame.minY + 8,
                                  width: bounds.width - (avatarImageView.frame.maxX + 50),
                                  height: 14)
    
    timeLabel.frame = CGRect(x: userInforLabel.frame.minX,
                             y: userInforLabel.frame.maxY + 4,
                             width: userInforLabel.frame.width,
                             height: 14)
    
    avatarImageView.cornerRadius = avatarImageView.frame.width / 2
    menuButton.frame = CGRect(x: userInforLabel.frame.maxX, y: 0, width: bounds.width - userInforLabel.frame.maxX, height: bounds.height)
    menuButton.contentEdgeInsets = UIEdgeInsets(top: avatarImageView.frame.minY + 5, left: 0, bottom: 0, right: 0)
  }
  
  func configure(_ model: FeedPersonalInfoContent) {
    userInforLabel.text = model.user.name
    timeLabel.text = model.postShortInfo
    let avatarPlaceholder = UIImage(named: "")
    avatarImageView.image = avatarPlaceholder
    if let avatarURLStr = model.user.avatarURL {
      avatarImageView.kf.setImage(with: URL(string: avatarURLStr), placeholder: avatarPlaceholder)
    }
  }
}
