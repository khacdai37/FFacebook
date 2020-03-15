
import UIKit
public struct TextSize {
  private struct CacheEntry: Hashable, Equatable {
    let text: String
    let font: UIFont
    let width: CGFloat
    let insets: UIEdgeInsets
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(text)
      hasher.combine(width)
      hasher.combine(insets.top)
      hasher.combine(insets.left)
      hasher.combine(insets.bottom)
      hasher.combine(insets.right)
    }
    
    static private func ==(lhs: TextSize.CacheEntry, rhs: TextSize.CacheEntry) -> Bool {
      return lhs.width == rhs.width && lhs.insets == rhs.insets && lhs.text == rhs.text
    }
  }
  
  private static var cache = [CacheEntry: CGRect]() {
    didSet {
      assert(Thread.isMainThread)
    }
  }
  
  static func clearCache() {
    cache = [:]
  }
  
  public static func size(_ text: String, font: UIFont, width: CGFloat, insets: UIEdgeInsets = .zero) -> CGRect {
    let key = CacheEntry(text: text, font: font, width: width, insets: insets)
    if let hit = cache[key] {
      return hit
    }
    
    let constrainedSize = CGSize(width: width - insets.left - insets.right, height: .greatestFiniteMagnitude)
    let attributes = [NSAttributedString.Key.font: font]
    let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
    var bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
    bounds.size.width = width
    bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
    cache[key] = bounds
    return bounds
  }
  
  static func size(_ attributeStr: NSAttributedString, width: CGFloat, insets: UIEdgeInsets) -> CGRect {
    let constrainedSize = CGSize(width: width - insets.left - insets.right, height: .greatestFiniteMagnitude)
    let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
    var bounds = attributeStr.boundingRect(with: constrainedSize, options: options, context: nil)
    bounds.size.width = width
    bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
    return bounds
  }
  
  static func sizeCache(_ attributeStr: NSAttributedString, width: CGFloat, insets: UIEdgeInsets) -> CGRect {
    let key = CacheEntry(text: attributeStr.string, font: Font.systemRegularFont(), width: width, insets: insets)
    if let hit = cache[key] {
      return hit
    }
    let bounds = size(attributeStr, width: width, insets: insets)
    cache[key] = bounds
    return bounds
  }
  
}

struct Font {
  static func systemRegularFont(ofSize size: CGFloat = 12) -> UIFont {
    return UIFont.systemFont(ofSize: size)
  }
  static func systemBoldFont(ofSize size: CGFloat = 12) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
  }
  
}
