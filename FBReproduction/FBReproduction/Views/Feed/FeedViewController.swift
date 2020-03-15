//
//  FeedViewController.swift
//  FBReproduction
//
//  Created by Dai Nguyen Khac on 2/22/20.
//  Copyright © 2020 Dai Nguyen Khac. All rights reserved.
//

import UIKit
import SnapKit
class FeedViewController: UIViewController {
  lazy var collectionView: UICollectionView = {[unowned self] in
    let view = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout())
    view.backgroundColor = .fbBrightGray
    view.delegate = self
    view.dataSource = self
    return view
    }()
  var viewModel: FeedViewModel = FeedViewModel()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  func setupView() {
    navigationController?.navigationBar.barTintColor = .primary
    navigationController?.navigationBar.isTranslucent = false
    let brandTextLabel = UILabel()
    brandTextLabel.text = "RFacebook"
    brandTextLabel.font = Font.systemBoldFont(ofSize: 25)
    brandTextLabel.textColor = .white
    let leftBarItem = UIBarButtonItem(customView: brandTextLabel)
    navigationItem.leftBarButtonItem = leftBarItem
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    registerCell()
  }
  
  func bindViewModel() {
    
  }
  
  private func registerCell() {
    collectionView.register(PostPersonalInfoCell.self)
    collectionView.register(PostTextContentCell.self)
    collectionView.register(PostUserActionCell.self)
  }
  
}
extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = getCell(collectionView, cellForItemAt: indexPath)
    cell.backgroundColor = .white
    return cell
  }
  
  private func getCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let feed = viewModel.feeds[indexPath.section]
    let item = feed.items[indexPath.item]
    if let personalContent = item as? FeedPersonalInfoContent  {
      let cell = collectionView.dequeueCell(ofType: PostPersonalInfoCell.self, for: indexPath)
      cell.configure(personalContent)
      return cell
    }
    if let postTextContent = item as? FeedTextContent {
      let cell = collectionView.dequeueCell(ofType: PostTextContentCell.self, for: indexPath)
      cell.configure(postTextContent.content)
      return cell
    }
    
    if let userActionContent = item as? FeedUserActionContent {
      let cell = collectionView.dequeueCell(ofType: PostUserActionCell.self, for: indexPath)
      cell.configure(userActionContent)
      return cell
    }
    fatalError()
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.feeds.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxWidth = collectionView.bounds.width
    let feed = viewModel.feeds[indexPath.section]
    let item = feed.items[indexPath.item]    
    return item.expectContentSizeWith(width: maxWidth)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let feed = viewModel.feeds[indexPath.section]
    let item = feed.items[indexPath.item]
    if let textContent = item as? FeedTextContent {
      textContent.isCollapsed.toggle()
      collectionView.reloadItems(at: [indexPath])
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
  }
  
}

class FeedViewModel {
  private(set) var feeds = Mockup.feeds
}
