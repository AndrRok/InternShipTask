import UIKit

final class MainVC: DataLoadingVC {
    
    enum Section{case main}
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemModel>!
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createMainLayout(in: view))
    private var itemsArray: [ItemModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "MyName")
        configure()
        configureDataSource()
        getItemsList()
    }
    
    private func configure(){
        configureCollectionView()
    }
    
    //MARK: - Network calls
    private func getItemsList(){
        showLoadingView()
        NetworkManager.shared.getMainRequest() { [weak self] result in
            guard let self = self else { return }
            dismissLoadingView()
            switch result {
            case .success(let itemsResult):
                self.itemsArray = itemsResult.advertisements
                self.updateDataSource(on: itemsResult.advertisements)
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: String(localized: "Bad Stuff Happend"), message: error.rawValue, butonTitle: String(localized: "Ok"))
            }
        }
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, ItemModel>(collectionView: collectionView, cellProvider: {(collectionView, indexPath, item)-> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.reuseID, for: indexPath) as? MainCell
            cell?.setFromAPI(item: item)
            cell?.layoutIfNeeded()
            return cell
        })
    }
    
    func updateDataSource(on dataResult: [ItemModel] ){
        var snapShot = NSDiffableDataSourceSnapshot<Section, ItemModel>()
        snapShot.appendSections([.main])
        snapShot.appendItems(dataResult)
        DispatchQueue.main.async { self.dataSource.apply(snapShot, animatingDifferences: true) }
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.reuseID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        collectionView.contentInset = insets
        collectionView.backgroundColor = .systemGray3
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}


//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemsArray[indexPath.row]
        self.presentCustomDetailsVCOnMainThred(itemID: item.id)
    }
}
