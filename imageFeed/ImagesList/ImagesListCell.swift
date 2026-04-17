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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.setImage(UIImage(resource: .likeButtonInactiveIcon), for: .normal)
        likeButton.setImage(UIImage(resource: .likeButtonActiveIcon), for: .selected)
    }
    
    //MARK: - IB Actions
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLikeButton(self)
    }
}
