//
//  BookCell.swift
//  RxLibrary
//
//  Created by Tin Pham on 1/2/26.
//

import UIKit
import Kingfisher

class BookCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycles
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        coverImageView.image = nil
        coverImageView.kf.cancelDownloadTask()
    }
}

// MARK: - Internal

extension BookCell {
    func configure(with book: Book, isLast: Bool) {
        label.text = book.title
        let placeholder = UIImage(named: "BookPlaceholder")
        
        separatorView.isHidden = isLast
        
        if let url = book.coverURL {
            coverImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            coverImageView.image = placeholder
        }
    }
}

// MARK: - Private

extension BookCell {
    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.addSubview(coverImageView)
        contentView.addSubview(label)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 80),
            
            label.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: coverImageView.topAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
}
