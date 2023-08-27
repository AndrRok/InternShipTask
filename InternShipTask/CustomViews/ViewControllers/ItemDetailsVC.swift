import UIKit


final class ItemDetailsVC: UIViewController {
    
    private let containerView = AlertContainerView()
    private let itemImageView = ItemImage(frame: .zero)
    private let titleLabel = MainLabel(textAlignment: .left, fontSize: 16, weight: .medium)
    private let priceLabel = MainLabel(textAlignment: .left, fontSize: 12, weight: .medium)
    private let location = MainLabel(textAlignment: .left, fontSize: 12, weight: .medium)
    private let createdDate = MainLabel(textAlignment: .left, fontSize: 12, weight: .medium)
    private let descriptionLabel = MainLabel(textAlignment: .left, fontSize: 12, weight: .medium)
    private let email = MainLabel(textAlignment: .left, fontSize: 12, weight: .medium)
    private let phoneNumber = MainLabel(textAlignment: .left, fontSize: 12, weight: .medium)
    private let address = MainLabel(textAlignment: .left, fontSize: 12, weight: .medium)
    private let actionButton = UIButton()
    private let addToFavoritesButton  = UIButton()
    private let closeButton   = UIButton()
    private let imageContainer = UIView()
    private let padding: CGFloat = 10
    private var itemID: String
    private var item: DetailModel?
    
    init(itemID: String) {
        self.itemID = itemID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItem()
    }
    
    private func configure(){
        view.backgroundColor =  UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureImageView()
        configureCloseButton()
        configureAddToFavoritesButton()
        configureTitleLabel()
        configureActionButton()
        configurePriceLabel()
        configureLocationLabel()
        configureDescriptionLabel()
        configureEmailLabel()
        configurePhoneNumberLabel()
        configureCreatedDateLabel()
    }
    
    //MARK: - Network calls
    private func getItem(){
        NetworkManager.shared.getDetails(id: itemID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let itemResult):
                self.item = itemResult
                DispatchQueue.main.async {
                    
                    self.configure()
                }
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: String(localized: "Bad Stuff Happend"), message: error.rawValue, butonTitle: String(localized: "Ok"))
            }
        }
    }
    
    private func configureContainerView(){
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 446)
        ])
    }
    
    
    //MARK: - Configure UI
    private func configureImageView(){
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.backgroundColor = Colors.lightBrown
        imageContainer.layer.cornerRadius =  10
        containerView.addSubview(imageContainer)
        imageContainer.addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.layer.cornerRadius =  10
        itemImageView.downloadImage(fromURL: item?.imageUrl ?? "")
        
        NSLayoutConstraint.activate([
            imageContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            imageContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            imageContainer.heightAnchor.constraint(equalToConstant: 150),
            
            itemImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            itemImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 130),
            itemImageView.heightAnchor.constraint(equalToConstant: 130),
        ])
    }
    
    private func configureCloseButton(){
        containerView.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = .white
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.layer.cornerRadius = 8
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.black.cgColor
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -8),
            closeButton.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 8),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureAddToFavoritesButton(){
        containerView.addSubview(addToFavoritesButton)
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.backgroundColor = .white
        addToFavoritesButton.setImage(UIImage(systemName: "heart"), for: .normal)
        addToFavoritesButton.tintColor = .black
        addToFavoritesButton.layer.cornerRadius = 8
        addToFavoritesButton.layer.borderWidth = 1
        addToFavoritesButton.layer.borderColor = UIColor.black.cgColor
        
        
        NSLayoutConstraint.activate([
            addToFavoritesButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            addToFavoritesButton.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 8),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 40),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTitleLabel(){
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleLabel.text = item?.title
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureActionButton(){
        containerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitleColor(.label, for: .normal)
        actionButton.setTitle(String(localized: "Добавить в корзину"), for: .normal)
        actionButton.backgroundColor = Colors.originalBlue
        actionButton.layer.cornerRadius = 10
        actionButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        actionButton.setTitleColor(.white, for: .normal)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configurePriceLabel(){
        containerView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .left
        priceLabel.text = item?.price
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        ])
    }
    
    private func configureLocationLabel(){
        containerView.addSubview(location)
        location.translatesAutoresizingMaskIntoConstraints = false
        location.numberOfLines = 0
        location.textAlignment = .left
        location.textColor = .systemGray2
        location.text = (item?.location ?? "") + ", " + (item?.address ?? "")
        
        NSLayoutConstraint.activate([
            location.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            location.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
        ])
    }
    
    
    private func configureDescriptionLabel(){
        containerView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .systemGray
        descriptionLabel.text = item?.description
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    private func configureCreatedDateLabel(){
        containerView.addSubview(createdDate)
        createdDate.translatesAutoresizingMaskIntoConstraints = false
        createdDate.numberOfLines = 0
        createdDate.textAlignment = .left
        createdDate.textColor = .systemGray
        createdDate.text = String(localized: "Объявление создано: ") + (item?.createdDate ?? "???")
        
        NSLayoutConstraint.activate([
            createdDate.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor, constant: 10),
            createdDate.leadingAnchor.constraint(equalTo: phoneNumber.leadingAnchor),
            createdDate.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    private func configureEmailLabel(){
        containerView.addSubview(email)
        email.translatesAutoresizingMaskIntoConstraints = false
        email.numberOfLines = 0
        email.textAlignment = .left
        email.textColor = .systemGray
        email.text = item?.email
        
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            email.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            email.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    private func configurePhoneNumberLabel(){
        containerView.addSubview(phoneNumber)
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.numberOfLines = 0
        phoneNumber.textAlignment = .left
        phoneNumber.textColor = .systemGray
        phoneNumber.text = item?.phoneNumber
        
        NSLayoutConstraint.activate([
            phoneNumber.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10),
            phoneNumber.leadingAnchor.constraint(equalTo: email.leadingAnchor),
            phoneNumber.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
        ])
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addToCart(){
        print("Added to cart")
    }
}

