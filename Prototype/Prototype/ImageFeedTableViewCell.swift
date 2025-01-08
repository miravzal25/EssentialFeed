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
        feedImageContainerView.startShimmering()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        feedImageView.alpha = 0
        feedImageContainerView.startShimmering()
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
            withDuration: 0.25,
            delay: 1.25,
            options: [],
            animations: {
                self.feedImageView.alpha = 1
            }, completion: { isCompleted in
                if isCompleted {
                    self.feedImageContainerView.stopShimmering()
                }
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

private extension UIView {
    private var shimmerAnimationKey: String {
        return "shimmer"
    }

    func startShimmering() {
        let white = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.7).cgColor
        let width = bounds.width
        let height = bounds.height

        let gradient = CAGradientLayer()
        gradient.colors = [alpha, white, alpha]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
        gradient.locations = [0.4, 0.5, 0.6]
        gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
        layer.mask = gradient

        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: shimmerAnimationKey)
    }

    func stopShimmering() {
        layer.mask = nil
    }
}
