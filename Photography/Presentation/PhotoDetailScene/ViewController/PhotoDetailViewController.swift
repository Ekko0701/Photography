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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
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
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        setUI()
    }
    
    private func setUI() {
        self.view.addSubview(photoImageView)
        self.photoImageView.snp.makeConstraints {
            // $0.top.equalTo(userNameLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            // $0.bottom.equalTo(titleLabel.snp.top).offset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        self.view.addSubview(closeButton)
        self.closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(36)
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
        
        self.view.addSubview(userNameLabel)
        self.userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.leading.equalTo(closeButton.snp.trailing).offset(16)
            $0.trailing.equalTo(downloadButton.snp.leading).offset(-16)
        }
        
        self.view.addSubview(tagsLabel)
        self.tagsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-56)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        self.view.addSubview(descriptionLabel)
        self.descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(tagsLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-56)
        }
        
        self.view.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-48)
        }
        
        

    
    }
    
    private func bindViewModel() {
        guard let viewModel = self.photoDetailViewModel else { return }
        
        let input = PhotoDetailViewModel.Input(
            viewDidLoad: self.rx.methodInvoked(#selector(UIViewController.viewDidLoad)).map { _ in }
        )
        
        let output = viewModel.transform(
            from: input,
            disposeBag: disposeBag
        )
        
        output.didLoadPhotoDetail
            .drive(onNext: { [weak self] photoDetail in
                print("디테일 \(photoDetail)")
                self?.userNameLabel.text = photoDetail.userName
                self?.titleLabel.text = photoDetail.slug
                self?.descriptionLabel.text = photoDetail.description
                self?.tagsLabel.text = photoDetail.tags.map { "#\($0)" }.joined(separator: " ")
                self?.setImage(with: photoDetail.imageURL)
                self?.resizeImageView(
                    width: CGFloat(photoDetail.width),
                    height: CGFloat(photoDetail.height)
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func setImage(with photoURL: String) {
        NukeExtensions.loadImage(with: URL(string: photoURL), into: self.photoImageView)
    }
    
    private func resizeImageView(width: CGFloat, height: CGFloat) {
        let ratio = width / height
        let newHeight = (self.view.frame.width - 20) / ratio
        self.photoImageView.snp.updateConstraints {
            $0.height.equalTo(newHeight)
        }
    }
}
