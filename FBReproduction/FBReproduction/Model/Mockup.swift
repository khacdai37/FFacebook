//
//  Mockup.swift
//  FBReproduction
//
//  Created by Dai Nguyen Khac on 2/23/20.
//  Copyright © 2020 Dai Nguyen Khac. All rights reserved.
//

import Foundation
struct Mockup {
  static let feeds: [UserFeedItem] = {
    Array(1...10).map { PostItem(id: $0, author: users.shuffled().first!, createdAt: "Today", content: Lorem.paragraphs(), images: nil, imageMax: 0, likeNumber: 1, commentNumber: 1, likedByMe: false, postType: PostCategory(id: $0, name: Lorem.words())) }.map(UserFeedItem.init)
  }()
  
  static let users: [UserRepresentable] = {
    Array(1...20).map {User(id: $0, name: Lorem.words(), avatarURL: "https://i.picsum.photos/id/\($0)/200/200.jpg")}
  }()
}
