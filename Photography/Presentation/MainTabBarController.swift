//
//  MainTabBarController.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    // MARK: - Properties
    
    // MARK: - UI elements
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewControllers()
    }
    
    // MARK: - Private methods
    private func configureViewControllers() {
        let homeViewModel = HomeViewModel(
            photoListUseCase: DefaultPhotoListUseCase(
                photoRepository: DefaultPhotoListRepository(
                    alamofireService: DefaultAlamofireNetworkService()
                )
            )
        )
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let favoriteViewController = BookmarkViewController()
        favoriteViewController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), tag: 1)
        
        self.setViewControllers([homeViewController, favoriteViewController], animated: true)
    }
}
