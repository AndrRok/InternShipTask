//
//  MainVC.swift
//  InternShipTask
//
//  Created by ARMBP on 8/26/23.
//

import UIKit

final class MainVC: DataLoadingVC {
    
    enum Section{case main}
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ItemModel>!
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createMainLayout(in: view))
    private var itemsArray: [ItemModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Andrey Rokhmanov"
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
            self.dismissLoadingView()
            switch result {
            case .success(let itemsResult):
                self.itemsArray = itemsResult.advertisements
                self.updateDataSource(on: itemsResult.advertisements)
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, ItemModel>(collectionView: collectionView, cellProvider: {(collectionView, indexPath, item)-> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.reuseID, for: indexPath) as! MainCell
//            cell.imageView.image = nil
            cell.tag = indexPath.row
            cell.setFromAPI(item: item)
            return cell
        })
    }
    
    func updateDataSource(on randomImagesResults: [ItemModel] ){
        var snapShot = NSDiffableDataSourceSnapshot<Section, ItemModel>()
        snapShot.appendSections([.main])
        snapShot.appendItems(randomImagesResults)
        DispatchQueue.main.async { self.dataSource.apply(snapShot, animatingDifferences: true) }
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
       collectionView.delegate = self
//        collectionView.dataSource = self
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
