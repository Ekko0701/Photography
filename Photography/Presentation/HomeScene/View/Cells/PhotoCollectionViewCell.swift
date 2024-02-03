//
//  PhotoCollectionViewCell.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import UIKit

import NukeExtensions

@MainActor
class PhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "PhotoCollectionViewCell"
    
    
    // MARK: - UI elements
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemRed
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "image title"
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Private methods
    private func setUI() {
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(
        with photo: Photo
    ) {
        NukeExtensions.loadImage(with: URL(string: photo.imageURL), options: ImageLoadingOptions(placeholder: UIImage(systemName: "photo"), transition: .fadeIn(duration: 0.33)), into: imageView)
        titleLabel.text = photo.description
    }
}
