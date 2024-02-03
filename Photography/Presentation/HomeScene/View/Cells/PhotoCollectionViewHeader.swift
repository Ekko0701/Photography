//
//  PhotoCollectionViewHeader.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation
import UIKit

class PhotoCollectionViewHeader: UICollectionReusableView {
    // MARK: - Properties
    static let identifier = "PhotoCollectionViewHeader"
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Header"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setUI() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
