//
//  ImageFeedTableViewCell.swift
//  Prototype
//
//  Created by Miravzal Sultonov on 1/2/25.
//

import UIKit

final class ImageFeedTableViewCell: UITableViewCell {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.spacing = 6
        return stackView
    }()
    
    let pinContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .pin
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Label\nLabel"
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(hex: 0x9B9B9B)
        label.numberOfLines = 2
        return label
    }()
    
    let feedImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xE3E3E3)
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description"
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(hex: 0x4A4A4A)
        label.numberOfLines = 6
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        feedImageView.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedImageView.alpha = 0
    }
    
    func addSubviews() {
        pinContainerView.addSubview(pinImageView)
        feedImageContainerView.addSubview(feedImageView)
        
        locationStackView.addArrangedSubview(pinContainerView)
        locationStackView.addArrangedSubview(locationLabel)
        
        stackView.addArrangedSubview(locationStackView)
        stackView.addArrangedSubview(feedImageContainerView)
        stackView.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(stackView)
    }
    
    func setConstraints() {
        let topAnchor = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        topAnchor.priority = UILayoutPriority(999)
        topAnchor.isActive = true
        
        let bottomAnchor = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        bottomAnchor.priority = UILayoutPriority(999)
        bottomAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            locationStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            pinContainerView.widthAnchor.constraint(equalToConstant: 10),
            
            pinImageView.heightAnchor.constraint(equalToConstant: 14),
            pinImageView.topAnchor.constraint(equalTo: pinContainerView.topAnchor, constant: 3),
            pinImageView.leadingAnchor.constraint(equalTo: pinContainerView.leadingAnchor),
            
            feedImageContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            feedImageContainerView.heightAnchor.constraint(equalTo: feedImageContainerView.widthAnchor),
            
            feedImageView.topAnchor.constraint(equalTo: feedImageContainerView.topAnchor),
            feedImageView.leadingAnchor.constraint(equalTo: feedImageContainerView.leadingAnchor),
            feedImageView.bottomAnchor.constraint(equalTo: feedImageContainerView.bottomAnchor),
            feedImageView.trailingAnchor.constraint(equalTo: feedImageContainerView.trailingAnchor),
        ])
    }
    
    func fadeIn(_ image: UIImage?) {
        feedImageView.image = image
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.3,
            options: [],
            animations: {
                self.feedImageView.alpha = 1
            })
    }
}

extension ImageFeedTableViewCell {
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationStackView.isHidden = model.location == nil

        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil

        fadeIn(UIImage(named: model.imageName))
    }
}
