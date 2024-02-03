//
//  PhotoCardView.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation
import UIKit

import SwiftUI
import RxRelay
import RxSwift
import NukeExtensions

final class PhotoCardView: UIView {
    
    // MARK: - Properties
    private let photo: Photo
    
    // MARK: - UI components
    private lazy var backgroundView: UIView = {
        let background = UIView()
        background.backgroundColor = .white
        background.layer.cornerRadius = 10
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowRadius = 25
        background.layer.shadowOpacity = 0.12
        background.layer.shadowOffset = CGSize(width: 0, height: 4)
        return background
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
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
        let xImage = UIImage(named: "x")?.resized(to: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate)
        button.setImage(xImage, for: .normal)
        button.tintColor = .gray60
        button.layer.cornerRadius = 26
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray30.cgColor
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        let bookmarkImage = UIImage(named: "bookmark")?.resized(to: CGSize(width: 29.33, height: 31.72)).withRenderingMode(.alwaysTemplate)
        button.setImage(bookmarkImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .brandColor
        button.layer.cornerRadius = 36
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        let informationImage = UIImage(named: "information")?.resized(to: CGSize(width: 36, height: 36)).withRenderingMode(.alwaysTemplate)
        button.setImage(informationImage, for: .normal)
        button.tintColor = .gray60
        button.layer.cornerRadius = 26
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray30.cgColor
        return button
    }()
    
    init(
        with photo: Photo
    ) {
        self.photo = photo
        super.init(frame: .zero)
        setUI()
        setImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        // self.layer.cornerRadius = 10
        
        
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
    
    func cardViewBinding(bookmarkButtonTapped: PublishRelay<Void>,
                         removeButtonTapped: PublishRelay<Void>,
                         infoButtonTapped: PublishRelay<Void>,
                         disposeBag: DisposeBag) {
        bookmarkButton.rx.tap
            .bind(to: bookmarkButtonTapped)
            .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .bind(to: removeButtonTapped)
            .disposed(by: disposeBag)
        
        infoButton.rx.tap
            .bind(to: infoButtonTapped)
            .disposed(by: disposeBag)}
}

//#Preview {
//    PhotoCardView()
//}
