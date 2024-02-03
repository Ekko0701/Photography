//
//  PhotoCardView.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation
import UIKit

import SwiftUI
import NukeExtensions

final class PhotoCardView: UIView {
    
    // MARK: - Properties
    private let photo: Photo
    
    // MARK: - UI components
    private lazy var backgroundView: UIView = {
      let background = UIView()
      background.clipsToBounds = true
      background.layer.cornerRadius = 10
      return background
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "x"), for: .normal)
        button.tintColor = .gray30
        button.layer.cornerRadius = 26
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray30.cgColor
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmark"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 36
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "information"), for: .normal)
        button.tintColor = .gray30
        button.layer.cornerRadius = 26
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray30.cgColor
        return button
    }()
    
    init(with photo: Photo) {
        self.photo = photo
        super.init(frame: .zero)
        setUI()
        setImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .gray30
        imageView.backgroundColor = .black
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 10
        
        self.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        backgroundView.addSubview(buttonView)
        buttonView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(48)
            $0.centerX.equalToSuperview()
        }
        
        self.buttonView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.width.height.equalTo(72)
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        self.buttonView.addSubview(removeButton)
        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(52)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        self.buttonView.addSubview(infoButton)
        infoButton.snp.makeConstraints {
            $0.width.height.equalTo(52)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setImage() {
        NukeExtensions.loadImage(with: URL(string: photo.imageURL), options: ImageLoadingOptions(placeholder: UIImage(systemName: "photo"), transition: .fadeIn(duration: 0.33)), into: imageView)
    }
}

//#Preview {
//    PhotoCardView()
//}
