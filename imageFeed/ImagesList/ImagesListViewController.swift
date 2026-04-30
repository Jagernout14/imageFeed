import UIKit
import Kingfisher

protocol ImagesListViewProtocol: AnyObject {
    func reloadData()
    func insertRows(at indexPaths: [IndexPath])
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}

// MARK: - ImageListViewController
final class ImagesListViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public Properties
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Private Properties
    private let showSingleImageIdentifier = AccessibilityIdentifiers.ImagesListView.showSingleImage
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  setupPresenter()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == showSingleImageIdentifier,
            let indexPath = sender as? IndexPath,
            let photo = presenter?.photo(at: indexPath.row),
            let destination = segue.destination as? SingleImageViewController
        else { return }
        destination.imageUrl = URL(string: photo.largeImageURL)
    }
    
    // MARK: - Private Methods
    private func setupPresenter() {
        let presenter = ImagesListPresenter()
        presenter.view = self
        self.presenter = presenter
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let presenter,
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath
            ) as? ImagesListCell
        else {
            return UITableViewCell()
        }
        
        if let photo = presenter.photo(at: indexPath.row) {
            cell.showAnimation()
            
            guard let url = URL(string: photo.thumbImageURL) else {
                cell.cellImage.image = UIImage(resource: .cellStubIcon)
                cell.hideAnimation()
                return cell
            }
            
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(
                with: url,
                placeholder: UIImage(resource: .cellStubIcon)
            ) { _ in
                cell.hideAnimation()
                guard
                    let currentIndexPath = tableView.indexPath(for: cell),
                    currentIndexPath == indexPath
                else { return }
            }
            
            cell.delegate = self
            cell.likeButton.isSelected = photo.isLiked
            if let date = photo.createdAt {
                cell.dateLabel.text = dateFormatter.string(from: date)
            } else {
                cell.dateLabel.text = "Дата не указана"
            }
        } else {
            cell.cellImage.image = UIImage(resource: .cellStubIcon)
            cell.dateLabel.text = "Ошибка загрузки"
            cell.hideAnimation()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard
            let photo = presenter?.photo(at: indexPath.row),
            photo.size.width > 0
        else {
            return 200
        }
        
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        return max(cellHeight, 200)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLikeButton(_ cell: ImagesListCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let presenter = presenter
        else { return }
        presenter.didTapLike(at: indexPath.row)
    }
}

extension ImagesListViewController: ImagesListViewProtocol {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func insertRows(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates {
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            UIBlockingProgressHUD.dismiss()
        }
    }
}
