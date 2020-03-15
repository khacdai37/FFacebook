//
//  User.swift
//  FBReproduction
//
//  Created by Dai Nguyen Khac on 2/23/20.
//  Copyright © 2020 Dai Nguyen Khac. All rights reserved.
//

import Foundation
protocol UserRepresentable {
  var id: Int { get }
  var name: String! { get }
  var avatarURL: String? { get }
}
class User: UserRepresentable {
  var id: Int
  var name: String!
  var avatarURL: String?
  init(id: Int, name: String, avatarURL: String?) {
    self.id = id
    self.name = name
    self.avatarURL = avatarURL
  }
}
