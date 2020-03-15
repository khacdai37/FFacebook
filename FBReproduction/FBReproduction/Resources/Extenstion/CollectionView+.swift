//
//  CollectionView.swift
//
//  Created by Dai Nguyen Khac on 2/22/20.
//  Copyright © 2020 Dai Nguyen Khac. All rights reserved.
//

#if os(iOS)
import UIKit
extension UICollectionView {
  func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
    register(cellClass, forCellWithReuseIdentifier: String(describing: T.self))
  }
  
  func register<T: UICollectionViewCell>(_ nib: UINib? = UINib(nibName: String(describing: T.self), bundle: nil), cellClassOfNib cellClass: T.Type) {
    register(nib, forCellWithReuseIdentifier: String(describing: T.self))
  }
  
  func register<T: UICollectionReusableView>(_ reusableViewClass: T.Type, forSupplementaryViewOfKind kind: String) {
    register(reusableViewClass,
             forSupplementaryViewOfKind: kind,
             withReuseIdentifier: String(describing: T.self))
  }
  
  func register<T: UICollectionReusableView>(_ nib: UINib? = UINib(nibName: String(describing: T.self), bundle: nil), headerFooterClassOfNib headerFooterClass: T.Type, forSupplementaryViewOfKind kind: String) {
    register(nib,
             forSupplementaryViewOfKind: kind,
             withReuseIdentifier: String(describing: T.self))
  }
  
  func dequeueCell<T>(ofType type: T.Type, for indexPath: IndexPath) -> T {
    return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
  }
  
  func dequeueReusableHeaderView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
    return dequeueReusableSupplementaryView(viewClass, kind: UICollectionView.elementKindSectionHeader, for: indexPath)
  }
  
  func dequeueReusableFooterView<T: UICollectionReusableView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
    return dequeueReusableSupplementaryView(viewClass, kind: UICollectionView.elementKindSectionFooter, for: indexPath)
  }
  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ viewClass: T.Type, kind: String, for indexPath: IndexPath) -> T {
    let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: T.self), for: indexPath)
    guard let viewType = view as? T else {
      fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(String(describing: T.self))")
    }
    return viewType
  }
}
#elseif os(OSX)
#endif
