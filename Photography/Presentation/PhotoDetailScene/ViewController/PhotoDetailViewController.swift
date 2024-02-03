//
//  PhotoDetailViewController.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import NukeExtensions

class PhotoDetailViewController: UIViewController {
    // MARK: - Properties
    private var photoDetailViewModel: PhotoDetailViewModel?
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let xImage = UIImage(named: "x")?.resized(to: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
        button.setImage(xImage, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        return button
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User name"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        let downloadImage = UIImage(named: "download")?.resized(to: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
        button.setImage(downloadImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        let bookmarkImage = UIImage(named: "bookmark")?.resized(to: CGSize(width: 24, height: 24)).withRenderingMode(.alwaysTemplate)
        button.setImage(bookmarkImage, for: .normal)
        button.tintColor = .white.withAlphaComponent(0.2)
        return button
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "#tags"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialize
    init(viewModel: PhotoDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.photoDetailViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        setUI()
        setImage()
    }
    
    private func setUI() {
        self.view.addSubview(closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(36)
        }
        
        self.view.addSubview(userNameLabel)
        self.userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.leading.equalTo(closeButton.snp.trailing).offset(16)
        }
        
        self.view.addSubview(bookmarkButton)
        self.bookmarkButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(closeButton)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(downloadButton)
        self.downloadButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-24)
            $0.centerY.equalTo(closeButton)
        }
        
        self.view.addSubview(tagsLabel)
        self.tagsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        self.view.addSubview(descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(tagsLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        self.view.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        self.view.addSubview(photoImageView)
        self.photoImageView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(titleLabel.snp.top).offset(16)
        }

    
    }
    
    func setImage() {
        NukeExtensions.loadImage(with: URL(string: "https://images.unsplash.com/photo-1706800695853-f18ba83a6341?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NjI3NjJ8MHwxfGFsbHwzfHx8fHx8Mnx8MTcwNjk5MjI4OHw&ixlib=rb-4.0.3&q=80&w=1080")!, into: self.photoImageView)
        
        // https://images.unsplash.com/photo-1706800695853-f18ba83a6341?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NjI3NjJ8MHwxfGFsbHwzfHx8fHx8Mnx8MTcwNjk5MjI4OHw&ixlib=rb-4.0.3&q=80&w=1080
    }
}

#Preview {
    let viewModel = PhotoDetailViewModel()
    let viewController = PhotoDetailViewController(viewModel: viewModel)
    return viewController
}
