//
//  SettingApp.swift
//
//  Created by Dai Nguyen Khac on 8/23/16.
//  Copyright © 2016 Dai Nguyen Khac. All rights reserved.
//

import UIKit
class AppSetting: NSObject {
  class func language(_ lang: Languages = .English) {
    language(lang.code())
  }
  
  static func language(_ code: String) {
     UserDefaults.standard.set(code, forKey: kLanguages)
     UserDefaults.standard.synchronize()
   }
  
}

extension AppSetting {}

struct AppConstant {
 
}

enum Languages: Int {
  case None = 0
  case English = 1
  case Vietnamese
  case Japanese
  case Korean
  
  var locale: Locale {
    switch self {
    case .Vietnamese:
      return Locale(identifier: "vi-VN")
    case .Korean:
      return Locale(identifier: "ko-KR")
    default:
      return Locale(identifier: "en_US")
    }
  }
  
  func code() -> String {
    switch self {
    case .English:
      return "en"
    case .Vietnamese:
      return "vi"
    default:
      return ""
    }
  }
  
  func localization(with code: String? = nil) -> String {
    switch self {
    case .English:
      return LocalizedString(key: "language.title.english", languageCode: code)
    case .Vietnamese:
      return LocalizedString(key: "language.title.vietnamese", languageCode: code)
    case .Korean:
      return LocalizedString(key: "language.title.korean")
    default:
      return "nil"
    }
  }
  
  func contryCode() -> String {
    switch self {
    case .English:
      return "EN"
    case .Vietnamese:
      return "VN"
    case .Korean:
      return "KR"
    default:
      return "KR"
    }
  }
  
  static func languageWith(code: String?) -> Languages {
    switch code {
    case "en":
      return .English
    case "ja":
      return .Japanese
    case "vi":
      return .Vietnamese
    default:
      return .None
    }
  }
  static func languageWith(contryCode: String?) -> Languages {
    switch contryCode {
    case "en":
      return .English
    case "kr":
      return .Korean
    case "vn":
      return .Vietnamese
    default:
      return .None
    }
  }
}

