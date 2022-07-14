//
//  ServicesTableViewCell.swift
//  VKServices
//
//  Created by Dinar Garaev on 13.07.2022.
//

import UIKit

/// Ячейки представления сервисов
final class ServicesTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let rightArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleToFill
        imageView.tintColor = UIColor(hexString: "FFFFFF", alpha: 0.2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func setupCell(with service: Service) {
        mainLabel.text = service.name
        
        descriptionLabel.text = service.description
        guard let imageURL = URL(string: service.icon_url) else { return }
        let task = URLSession.shared.dataTask(with: imageURL) {  [weak self] data, _, error  in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.iconView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        addSubview(iconView)
        addSubview(rightArrowImageView)
        addSubview(mainLabel)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: 18),
            iconView.widthAnchor.constraint(equalToConstant: 62),
            iconView.heightAnchor.constraint(equalToConstant: 62),
            
            rightArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightArrowImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -18),
            
            mainLabel.topAnchor.constraint(equalTo: iconView.topAnchor),
            mainLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 20),

            descriptionLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            descriptionLabel.rightAnchor.constraint(equalTo: rightArrowImageView.leftAnchor, constant: -18),
            descriptionLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor)
        ])
    }
}
