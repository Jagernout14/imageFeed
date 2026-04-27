import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        // MARK: - Images List
        let imagesListVC = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as! ImagesListViewController
        
        let imagesPresenter = ImagesListPresenter()
        imagesListVC.presenter = imagesPresenter
        imagesPresenter.view = imagesListVC
        
        imagesListVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditorialActiveIcon),
            selectedImage: nil
        )
        
        // MARK: - Profile
        let profileVC = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        
        profileVC.presenter = profilePresenter
        profilePresenter.view = profileVC
        profileVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActiveIcon),
            selectedImage: nil
        )
        
        viewControllers = [imagesListVC, profileVC]
    }
}
