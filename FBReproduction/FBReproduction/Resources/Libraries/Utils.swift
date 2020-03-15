//
//  Utils.swift
//
//  Created by Dai Nguyen Khac on 8/23/16.
//  Copyright © 2016 Dai Nguyen Khac. All rights reserved.
//

import UIKit
let kLanguages = "LanguageCode"
func LocalizedString(key: String, languageCode: String? = nil) -> String {
  var code = languageCode
  if code == nil {
    code = UserDefaults.standard.string(forKey: kLanguages) ?? "en"
  }
  if let path = Bundle.main.path(forResource: code, ofType: "lproj"), let languageBundle = Bundle.init(path: path){
    return languageBundle.localizedString(forKey: key, value: "", table: nil)
  }
  let rs = NSLocalizedString(key, comment: "")
  return rs
}

//MARK: - Helper
func delay(_ time: Int64, hanlde:@escaping ()->()) {
  let time_dp = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds) + Double(time * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
  DispatchQueue.main.asyncAfter(deadline: time_dp) {
    hanlde()
  }
}

//MARK: - Common View
@discardableResult
func showProgessView(inView view: UIView?, animated: Bool) -> MBProgressHUD {
  var _view = view
  if _view == nil {
    _view = UIApplication.shared.keyWindow?.rootViewController?.view
  }
  let hub = MBProgressHUD.showAdded(to: _view!, animated: animated)
  hub.backgroundView.color = .clear//UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
  hub.bezelView.color = UIColor.clear
  hub.bezelView.style = .solidColor
  hub.contentColor = .primary
  return hub
}

func showAlert(message: String?, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
  let alert = UIAlertController(title: "", message: message ?? "", preferredStyle: .alert)
  alert.preferredAction = alert.addActionWith(color: .primary, title: LocalizedString(key: "rt.action.close".localized()), handler: nil)
  UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
  
}

func dLog<T>(_ object: T?, filename: String = #file, line: Int = #line, funcname: String = #function) {
  #if RELEASE
  #else
  guard let object = object else { return }
  print("***** \(Date()) \(filename.components(separatedBy: "/").last ?? "") (line: \(line)) :: \(funcname) :: \(object)")
  #endif
}
