//
//  LoadingIndicatorReusableView.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation
import UIKit

class LoadingIndicatorReusableView: UICollectionReusableView {
    static let identifier = "LoadingIndicatorReusableView"
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
