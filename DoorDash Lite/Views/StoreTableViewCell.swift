//
//  StoreTableViewCell.swift
//  DoorDash Lite
//
//  Created by David Nadri on 3/5/19.
//  Copyright © 2019 David Nadri. All rights reserved.
//

import Foundation
import UIKit

class StoreTableViewCell: UITableViewCell {
    
    weak var coverImageView: UIImageView!
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
        label.textAlignment = .left
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var asapTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    func setupLayout() {
        configureImageView()
        configureLabels()
    }
    
    func configureImageView() {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        self.coverImageView = imageView
    }
    
    fileprivate func configureLabels() {
        self.addSubview(asapTimeLabel)
        NSLayoutConstraint.activate([
            asapTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            asapTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            asapTimeLabel.heightAnchor.constraint(equalToConstant: 20),
            asapTimeLabel.widthAnchor.constraint(equalToConstant: 50)
            ])
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, deliveryFeeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        stackView.spacing = 3.0
        self.contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: asapTimeLabel.leadingAnchor)
            ])

        layoutIfNeeded()
    }
    
    func configure(with store: Store) {
        
        let url = URL(string: store.coverImgURL)!
        
        // Natively download image from URL (you could use a third-party library for this but for our purposes...)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                        self.coverImageView.image = UIImage(data: data)
                    }, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.coverImageView.backgroundColor = .lightGray
                }
            }
        }
        
        self.nameLabel.text = store.name
        self.descriptionLabel.text = store.description
        self.deliveryFeeLabel.text = store.deliveryFee == 0 ? "Free delivery" : "$\(Float(store.deliveryFee) / Float(100)) delivery"
        if let asapTime = store.asapTime {
            self.asapTimeLabel.text = "\(asapTime) min"
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fatalError("Interface Builder is not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
