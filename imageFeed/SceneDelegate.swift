
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            return
        }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
    }
    
    func switchToMain() {
        guard let window = self.window else { return }
        let mainViewController = SplashViewController()
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
        
    }
}
