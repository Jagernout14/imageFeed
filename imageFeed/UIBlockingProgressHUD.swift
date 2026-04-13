import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        print("Animated ProgressHUD")
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        print("Stop animate ProgressHUD")
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
