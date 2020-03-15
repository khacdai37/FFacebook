//
//  Fd_PostTextContentCell.swift
//  dk236
//
//  Created by Nguyen Khac Dai on 11/27/19.
//  Copyright © 2019 dk236. All rights reserved.
//

import UIKit
class PostTextContentCell: UICollectionViewCell {
  static let font = Font.systemRegularFont()
  static let inset = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
  
  static func cellSize(width: CGFloat, text: String) -> CGSize {
    return TextSize.size(text, font: PostTextContentCell.font, width: width, insets: PostTextContentCell.inset).size
  }
  static var singleLineHeight: CGFloat {
    return inset.top + inset.bottom + font.lineHeight 
  }

  let textLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.numberOfLines = 0
    label.font = PostTextContentCell.font
    label.textColor = .black
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(textLabel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    textLabel.frame = bounds.inset(by: PostTextContentCell.inset)
  }
  
  func configure(_ model: NSAttributedString?) {
    textLabel.attributedText = model
  }
}




