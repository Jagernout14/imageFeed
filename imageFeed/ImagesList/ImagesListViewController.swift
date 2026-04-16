import UIKit
import Kingfisher

// MARK: - ImageListViewController
final class ImagesListViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    private let showSingleImageIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService()
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
                self?.updateTableViewAnimated()
            })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let photo = photos[indexPath.row]
            let url = URL(string: photo.largeImageURL)
            viewController.imageUrl = url
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    /* func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
     guard let image = UIImage(named: photosName[indexPath.row]) else { return }
     
     cell.cellImage.image = image
     cell.dateLabel.text = dateFormatter.string(from: Date())
     
     let isLiked = indexPath.row % 2 == 0
     let likeImage = isLiked ? UIImage(named: "LikeButtonActive_icon") : UIImage(named: "LikeButtonInactive_icon")
     cell.likeButton.setImage(likeImage, for: .normal)
     } */
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photo = photos[indexPath.row] //указываю откуда брать изображения
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else { //настраиваю ячейку
            return UITableViewCell()
        }
        guard let url = URL(string: photo.thumbImageURL) else {
            cell.cellImage.image = UIImage(resource: .cellStubIcon)
            return cell
        }
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(   // даю изображение в ячейку
            with: url,
            placeholder: UIImage(resource: .cellStubIcon)
        ) { result in
            guard let currentIndexPath = tableView.indexPath(for: cell),
                  currentIndexPath == indexPath else {
                return
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.likeButton.isSelected = photo.isLiked // лайки
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date) //дата из json
        } else {
            cell.dateLabel.text = "" // если дата не пришла
        }
        return cell //возвращаю ячейку
        
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        
        guard imageWidth > 0 else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        } else {
            return
        }
    }
}
