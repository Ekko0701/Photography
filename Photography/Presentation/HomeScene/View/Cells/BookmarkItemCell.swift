//
//  BookmarkItemCell.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation
import UIKit

class BookmarkItemCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "BookmarkItemCell"
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
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
        self.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
