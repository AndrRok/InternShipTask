import UIKit

extension UIViewController {
    
    func presentCustomAllertOnMainThred(allertTitle: String, message: String, butonTitle: String){
        DispatchQueue.main.async {
            let allertVC = AlertVC(allertTitle: allertTitle, message: message, buttonTitle: butonTitle)
            allertVC.modalPresentationStyle = .overFullScreen
            allertVC.modalTransitionStyle = .crossDissolve
            self.present(allertVC, animated: true)
        }
    }
    
    func presentCustomDetailsVCOnMainThred(itemID: String){
        DispatchQueue.main.async {
            let itemDetailsVC = ItemDetailsVC(itemID: itemID)
            itemDetailsVC.modalPresentationStyle = .overFullScreen
            itemDetailsVC.modalTransitionStyle = .crossDissolve
            self.present(itemDetailsVC, animated: true)
        }
    }
}

