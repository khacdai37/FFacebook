//
//  Extensions.swift
//
//  Created by Dai Nguyen Khac on 8/16/18.
//  Copyright © 2018 Dai Nguyen Khac. All rights reserved.
//

import UIKit
extension Notification.Name {
  static let ResetSearchFilteringValues = Notification.Name(rawValue: "com.dk.resetSearchFilteringValues")
}
extension NSLayoutConstraint {
  @IBInspectable var iPhone5: CGFloat {
    set {
      if (UIDevice.current.screenType == .iPhones_5_5s_5c_SE) {
        self.constant = newValue;
      }
    }
    get {
      return self.constant;
    }
  }
}

extension Bundle {
  static var versionNumber: String {
    return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0"
  }
}

extension UIDevice {
  enum iOSVersion {
    case unknow
    case iOS10, iOS11, iOS12, iOS13
  }
  var iOSVersion: iOSVersion {
    let os = ProcessInfo().operatingSystemVersion
    switch (os.majorVersion, os.minorVersion, os.patchVersion) {
    case (10, _, _):
      return .iOS10
    case (11, _, _):
      return .iOS11
    case (12, _, _):
      return .iOS12
    case (13, _, _):
      return .iOS13
    default:
      return .unknow
    }
  }
  class var hasBottomSafeAreaInsets: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
      // with home indicator: 34.0 on iPhone X, XS, XS Max, XR.
      // with home indicator: 20.0 on iPad Pro 12.9" 3rd generation.
      return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }
    return false
  }
  var iPhoneX: Bool {
    return UIScreen.main.nativeBounds.height == 2436
  }
  var iPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
  }
  enum ScreenType: String {
    case iPhones_4_4S = "iPhone 4 or iPhone 4S"
    case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
    case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
    case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
    case iPhones_X_XS = "iPhone X or iPhone XS"
    case iPhone_XR = "iPhone XR"
    case iPhone_XSMax = "iPhone XS Max"
    case unknown
  }
  var screenType: ScreenType {
    switch UIScreen.main.nativeBounds.height {
    case 960:
      return .iPhones_4_4S
    case 1136:
      return .iPhones_5_5s_5c_SE
    case 1334:
      return .iPhones_6_6s_7_8
    case 1792:
      return .iPhone_XR
    case 1920, 2208:
      return .iPhones_6Plus_6sPlus_7Plus_8Plus
    case 2436:
      return .iPhones_X_XS
    case 2688:
      return .iPhone_XSMax
    default:
      return .unknown
    }
  }
}

extension UIAlertController {
  class func initAlert(title: String? = nil, message: String?,
                       titleFont: UIFont = UIFont(name: "HiraginoSans-W3", size: 15.0)!,
                       messageFont: UIFont = UIFont(name: "HiraginoSans-W3", size: 11.0)!) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if let title = title {
      let titleAttribute = NSMutableAttributedString(string: title, attributes: [
        NSAttributedString.Key.font: titleFont,
        NSAttributedString.Key.foregroundColor: UIColor.darkGray
      ])
      alert.setValue(titleAttribute, forKey: "attributedTitle")
    }
    if let msg = message {
      let messageAttribute = NSMutableAttributedString(string: msg, attributes: [
        NSAttributedString.Key.font: messageFont,
        NSAttributedString.Key.foregroundColor: UIColor.darkGray
      ])
      alert.setValue(messageAttribute, forKey: "attributedMessage")
    }
    return alert
  }
  func addMessageWith(color: UIColor?, message: String) {
    let color = color ?? UIColor.black
    let customMessage = NSMutableAttributedString(string: message, attributes: [
      NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 18.0)!,
      NSAttributedString.Key.foregroundColor: color
    ])
    self.setValue(customMessage, forKey: "attributedMessage")
  }
  @discardableResult
  func addActionWith(color: UIColor?, title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> ())?) -> UIAlertAction {
    let color = color ?? UIColor.blue
    let action = UIAlertAction(title: title, style: style, handler: handler)
    action.setValue(color, forKey: "titleTextColor")
    self.addAction(action)
    return action;
  }
}

extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}
extension Date {
  var millisecondsSince1970:Int {
    return Int((self.timeIntervalSince1970 * 1000.0).rounded())
  }
  
  init(milliseconds:Int) {
    self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
  }
  
  func toString(formatter: DateFormatter) -> String {
    return formatter.string(from: self)
  }
  
  func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
    let currentCalendar = Calendar.current
    guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
    guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
    return end - start
  }
}
extension DateFormatter {
  static let client_formatter: DateFormatter = {
    let formatter = DateFormatter()
    //        formatter.locale = Locale(identifier: "en_US")
    //        formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "HH : mm   dd/MM/yyyy"
    return formatter
  }()
  static let server_fomartter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
  }()
  
}
extension String {
  func localized() -> String {
    return LocalizedString(key: self)
  }
  
  
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
    return ceil(boundingBox.height)
  }
  
  func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
    return ceil(boundingBox.width)
  }
  
  /*
   func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
   let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
   let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
   return boundingBox.height
   }
   */
  
}
extension UIView {
  func topRoundCorners(cornerRadius: Double) {
    roundCornerWith(rectCorner: [.topLeft, .topRight], cornerRadius: cornerRadius)
  }
  func bottomRoundCorners(cornerRadius: Double) {
    roundCornerWith(rectCorner: [.bottomLeft, .bottomRight], cornerRadius: cornerRadius)
  }
  func roundCornerWith(rectCorner: UIRectCorner, cornerRadius: Double) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    self.layer.mask = maskLayer
  }
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  
}
extension UIButton {
  func underlineText() {
    let customAttributes : [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    let attributeString = NSMutableAttributedString(string: self.titleLabel?.text ?? "",
                                                    attributes: customAttributes)
    self.setAttributedTitle(attributeString, for: .normal)
    
  }
  
  func centerTextAndImage(spacing: CGFloat) {
    let insetAmount = spacing / 2
    imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
    titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
  }
}
extension Formatter {
  static let withSeparator: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.groupingSeparator = ","
    formatter.numberStyle = .decimal
    return formatter
  }()
}

extension BinaryInteger {
  var formattedWithSeparator: String {
    return Formatter.withSeparator.string(for: self) ?? ""
  }
}

extension UIStackView {
  func removeAllArrangedSubviews() {
    let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }
    NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
    removedSubviews.forEach({ $0.removeFromSuperview() })
  }
}

extension UICollectionViewCell {
  func addShadow() {
    self.contentView.layer.cornerRadius = 5.0
    self.contentView.layer.borderWidth = 3.0
    self.contentView.layer.borderColor = UIColor.clear.cgColor
    self.contentView.layer.masksToBounds = true
    layer.addShadow()
  }
}

extension CALayer {
  class ShadowConfiguration {
    var shadowOffset: CGSize = .zero
    var shadowOpacity: Float = 0.2
    var shadowRadius: CGFloat = 8
    var shadowColor: CGColor = UIColor.black.cgColor
    var masksToBounds: Bool = false
    var shadowPath: CGPath?
    var cornerRadius: CGFloat = 0
  }
  
  func addShadow(configure: ((ShadowConfiguration) -> Void)? = nil ) {
    let config = ShadowConfiguration()
    config.shadowPath = UIBezierPath(rect: bounds).cgPath
    configure?(config)
    self.shadowOffset = config.shadowOffset
    self.shadowOpacity = config.shadowOpacity
    self.shadowRadius = config.shadowRadius
    self.shadowColor = config.shadowColor
    self.masksToBounds = config.masksToBounds
    self.shadowPath = config.shadowPath
    self.cornerRadius = config.cornerRadius
    if cornerRadius != 0 {
      addShadowWithRoundedCorners()
    }
  }
  
  func roundCorners(radius: CGFloat) {
    self.cornerRadius = radius
    if shadowOpacity != 0 {
      addShadowWithRoundedCorners()
    }
  }
  
  private func addShadowWithRoundedCorners() {
    if let contents = self.contents {
      masksToBounds = false
      sublayers?.filter{ $0.frame.equalTo(self.bounds) }
        .forEach{ $0.roundCorners(radius: self.cornerRadius) }
      self.contents = nil
      if let sublayer = sublayers?.first,
        sublayer.name == "Constants.contentLayerName" {
        
        sublayer.removeFromSuperlayer()
      }
      let contentLayer = CALayer()
      contentLayer.name = "Constants.contentLayerName"
      contentLayer.contents = contents
      contentLayer.frame = bounds
      contentLayer.cornerRadius = cornerRadius
      contentLayer.masksToBounds = true
      insertSublayer(contentLayer, at: 0)
    }
  }
}
//MARK: -

extension UIViewController {
  func customBackButton(imageNamed: String? = "btn_back", title: String? = nil) {
    if let imageNamed = imageNamed, let backImage = UIImage(named: imageNamed) {
      self.navigationController?.navigationBar.backIndicatorImage = backImage
      self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    if let title = title {
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
      
    }
  }
  
  func showAlerError(_ error: Error) {
    showAlert(message: "rt.title.request-data-error".localized())
  }
}

extension UITabBarController {
  open override var childForStatusBarStyle: UIViewController? {
    return selectedViewController
  }
}

extension UINavigationController {
  open override var childForStatusBarStyle: UIViewController? {
    return topViewController
  }
}
protocol NavigationControllerBackButtonDelegate {
  func shouldPopOnBackButtonPress() -> Bool
}
extension UINavigationController: UINavigationBarDelegate {
  public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
    // Prevents from a synchronization issue of popping too many navigation items
    // and not enough view controllers or viceversa from unusual tapping
    if viewControllers.count < navigationBar.items?.count ?? 0 {
      return true
    }
    
    // Check if we have a view controller that wants to respond to being popped
    var shouldPop = true
    if let viewController = topViewController as? NavigationControllerBackButtonDelegate {
      shouldPop = viewController.shouldPopOnBackButtonPress()
    }
    
    if (shouldPop) {
      DispatchQueue.main.async {
        self.popViewController(animated: true)
      }
    } else {
      // Prevent the back button from staying in an disabled state
      for view in navigationBar.subviews {
        if view.alpha < 1.0 {
          UIView.animate(withDuration: 0.25, animations: {
            view.alpha = 1.0
          })
        }
      }
      
    }
    return false
  }
}

extension UIColor {

  convenience init(rgb: (r: Int, g: Int, b: Int), alpha: CGFloat = 1) {
    self.init(red: rgb.r, green: rgb.g, blue: rgb.b)
  }
  static var primary = UIColor(rgb: (59,89,152))
  static var fbLightBlue = UIColor(rgb: (139,157,195))
  static var fbDarkGray = UIColor(rgb: (213,220,233))
  static var fbLightGray = UIColor(rgb: (247,247,247))
  static var fbBrightGray = UIColor(rgb: (233, 235, 238))
}


//MARK: - Third Party





