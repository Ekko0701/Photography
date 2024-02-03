//
//  BookmarkCell.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation
import UIKit

class BookMarkCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "BookMarkCell"
    private var bookmarks: [Photo] = []
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BookmarkItemCell.self, forCellWithReuseIdentifier: BookmarkItemCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(bookmarks: [Photo]) {
        self.bookmarks = bookmarks
        self.collectionView.reloadData()
    }
}

extension BookMarkCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkItemCell.identifier, for: indexPath) as? BookmarkItemCell else { return UICollectionViewCell() }
        cell.configure(with: bookmarks[indexPath.row])
        return cell
    }
}

extension BookMarkCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageWidth: CGFloat = self.bookmarks[indexPath.row].width
        let imageHeight: CGFloat = self.bookmarks[indexPath.row].height
        
        let imageViewHeight: CGFloat = 128
        
        let ratio = imageWidth / imageHeight
        let imageViewWidth: CGFloat = imageViewHeight / ratio
        
        return CGSize(width: imageViewWidth,
                      height: imageViewHeight)
    }
}
