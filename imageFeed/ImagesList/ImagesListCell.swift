import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    
    func imageListCellDidTapLikeButton(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
        hideAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer?.frame = cellImage.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.setImage(UIImage(resource: .likeButtonInactiveIcon), for: .normal)
        likeButton.setImage(UIImage(resource: .likeButtonActiveIcon), for: .selected)
        likeButton.accessibilityIdentifier = "likeButton"
        
    }
    
    //MARK: - IB Actions
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLikeButton(self)
    }
    
    //MARK: - Set animation
    private var gradientLayer: CAGradientLayer?
    
    func showAnimation() {
        guard gradientLayer == nil else { return }
        let gradient = CAGradientLayer()
        gradient.frame = cellImage.bounds
        gradient.colors = [
            UIColor(white: 0.85, alpha: 1).cgColor,
            UIColor(white: 0.75, alpha: 1).cgColor,
            UIColor(white: 0.85, alpha: 1).cgColor
        ]
        
        gradient.locations = [0, 0.5, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 16
        gradient.masksToBounds = true
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        gradient.add(animation, forKey: "gradient")
        
        cellImage.layer.addSublayer(gradient)
        gradientLayer = gradient
    }
    
    func hideAnimation() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
}
