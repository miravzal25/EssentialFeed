//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Miravzal Sultonov on 1/12/25.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.spacing = 6
        return stackView
    }()
    
    public let pinContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .pin
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(hex: 0x9B9B9B)
        label.numberOfLines = 2
        return label
    }()
    
    public let feedImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xE3E3E3)
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(hex: 0x4A4A4A)
        label.numberOfLines = 6
        return label
    }()
    
    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    public var onRetry: (() -> Void)?
    public var onReuse: (() -> Void)?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse?()
    }
    
    public func addSubviews() {
        pinContainerView.addSubview(pinImageView)
        feedImageContainer.addSubview(feedImageView)
        
        locationStackView.addArrangedSubview(pinContainerView)
        locationStackView.addArrangedSubview(locationLabel)
        
        stackView.addArrangedSubview(locationStackView)
        stackView.addArrangedSubview(feedImageContainer)
        stackView.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(stackView)
    }
    
    public func setConstraints() {
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
            
            feedImageContainer.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            feedImageContainer.heightAnchor.constraint(equalTo: feedImageContainer.widthAnchor),
            
            feedImageView.topAnchor.constraint(equalTo: feedImageContainer.topAnchor),
            feedImageView.leadingAnchor.constraint(equalTo: feedImageContainer.leadingAnchor),
            feedImageView.bottomAnchor.constraint(equalTo: feedImageContainer.bottomAnchor),
            feedImageView.trailingAnchor.constraint(equalTo: feedImageContainer.trailingAnchor),
        ])
    }
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
