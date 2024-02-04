//
//  BookmarkItemCell.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation
import UIKit

import NukeExtensions

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
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
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
        
        self.imageView.addSubview(self.loadingIndicator)
        self.loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(with photo: Photo) {
        self.loadingIndicator.startAnimating()
        NukeExtensions.loadImage(
            with: URL(string: photo.imageURL),
            options: ImageLoadingOptions(placeholder: UIImage(), transition: .fadeIn(duration: 0.33)),
            into: imageView,
            completion: { [weak self] _ in
                self?.loadingIndicator.stopAnimating()
            }
        )
    }
}
