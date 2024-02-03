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
        self.view.backgroundColor = .white
        self.configureViewControllers()
    }
    
    // MARK: - Private methods
    private func configureViewControllers() {
        // ViewModel 생성
        let homeViewModel = HomeViewModel(
            photoListUseCase: DefaultPhotoListUseCase(
                photoRepository: DefaultPhotoListRepository(
                    alamofireService: DefaultAlamofireNetworkService()
                )
            )
        )
        
        let randomPhotoViewModel = RandomPhotoViewModel(
            randomPhotosUseCase: DefaultRandomPhotosUseCase(
                randomPhotosRepository: DefaultRandomPhotosRepository(
                    alamofireService: DefaultAlamofireNetworkService()
                ), realmRepository: DefaultRealmRepository(
                    realmService: DefaultRealmService()
                )
            )
        )
        
        // Tab Bar 디자인 커스텀
        self.tabBar.barTintColor = .black
        self.tabBar.isTranslucent = false
        
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.4)
        
        // ViewController 생성 및 설정
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "house"), tag: 0)
        homeNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let randomPhotoViewController = RandomPhotoViewController(viewModel: randomPhotoViewModel)
        let randomPhotoNavigationController = UINavigationController(rootViewController: randomPhotoViewController)
        randomPhotoNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "cards"), tag: 1)
        randomPhotoNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        self.setViewControllers([homeNavigationController, randomPhotoNavigationController], animated: false)
    }
}
