import UIKit


final class MainCell: UICollectionViewCell {
    
    public static let reuseID = "mainCell"
    private let nameLabel  = MainLabel(textAlignment: .left, fontSize: 14, weight: .medium)
    private let priceLabel  = MainLabel(textAlignment: .left, fontSize: 14, weight: .medium)
    private let locationLabel  = MainLabel(textAlignment: .left, fontSize: 14, weight: .medium)
    private let createdAtLabel  = MainLabel(textAlignment: .left, fontSize: 14, weight: .medium)
    private var container = UIView()
    private let imageView = ItemImage(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.setDefaultmage()
    }
    
    public func setFromAPI(item: ItemModel){
        nameLabel.text = item.title
        priceLabel.text = item.price
        locationLabel.text = item.location
        createdAtLabel.text = item.createdDate
        imageView.image = Images.placeholder
        imageView.downloadImage(fromURL: item.imageUrl)
    }
    
    private func configure(){
        addSubview(container)
        container.addSubviews(imageView, nameLabel, priceLabel, locationLabel, createdAtLabel)
        container.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints  = false
        priceLabel.translatesAutoresizingMaskIntoConstraints  = false
        locationLabel.translatesAutoresizingMaskIntoConstraints  = false
        createdAtLabel.translatesAutoresizingMaskIntoConstraints  = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        container.backgroundColor = Colors.lightBrown
        container.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.heightAnchor.constraint(equalToConstant: 110),
            container.widthAnchor.constraint(equalToConstant: 110),
            
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            
            createdAtLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            createdAtLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            createdAtLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
        ])
    }
    
}


