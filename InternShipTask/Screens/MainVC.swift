//
//  MainVC.swift
//  InternShipTask
//
//  Created by ARMBP on 8/26/23.
//

import UIKit

final class MainVC: DataLoadingVC {
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createMainLayout(in: view))
    private var itemsArray: [ItemModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Andrey Rokhmanov"
        configure()
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
                self.reloadCollectionView()
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    private func reloadCollectionView(){
        DispatchQueue.main.async{
            self.collectionView.reloadData()
            
        }
    }
}


//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.reuseID, for: indexPath) as! MainCell
        let item = itemsArray[indexPath.row]
        
        cell.tag = indexPath.row
        if (cell.tag == indexPath.row) {
            
            cell.setFromAPI(item: item)
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemsArray[indexPath.row]
        self.presentCustomDetailsVCOnMainThred(itemID: item.id)
    }
}
