import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        // MARK: - Images List
       guard let imagesListVC = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
       ) as? ImagesListViewController else { return }
        
        let imagesPresenter = ImagesListPresenter()
        imagesListVC.presenter = imagesPresenter
        imagesPresenter.view = imagesListVC
        
        imagesListVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditorialActiveIcon),
            selectedImage: nil
        )
        
        // MARK: - Profile
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActiveIcon),
            selectedImage: nil
        )
        
        viewControllers = [imagesListVC, profileViewController]
    }
}
