//
//  CommentTableVIewCell.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 03.07.2022.
//

import UIKit
import SnapKit

class CommentTableVIewCell: UITableViewCell {
    
    init(comment: Comment, user: User, avatarAction: @escaping (UUID) -> Void) {
        self.avatarAction = avatarAction
        self.comment = comment
        self.user = user
        
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let avatarAction: (UUID) -> Void
    private var comment: Comment {
        didSet {
            self.commentTextLabel.text = self.comment.text
        }
    }
    
    private var user: User {
        didSet {
            guard let imageString = self.user.image,
                  let dataImage = Data(base64Encoded: imageString) else {
                return
            }
            
            self.userAvatarImageView.image = UIImage(data: dataImage)
            self.userNameLabel.text = self.user.name
        }
    }
    
    private let userAvatarImageView: UIImageView = {
        let view = UIImageView()
        
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .textColor
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let commentTextLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func setuViews() {
        self.backgroundColor = .backgroundColor
        
        self.userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarImageViewDidTap)))
        self.userNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarImageViewDidTap)))
        
        self.userAvatarImageView.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        
        self.contentView.addSubview(self.userAvatarImageView)
        self.contentView.addSubview(self.userNameLabel)
        self.contentView.addSubview(self.commentTextLabel)
        
        self.userAvatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(30)
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.userAvatarImageView)
            make.leading.equalTo(self.userAvatarImageView.snp.trailing).inset(-10)
        }
        
        self.commentTextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userAvatarImageView.snp.bottom).inset(-15)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
        }
    }
    
    @objc private func avatarImageViewDidTap() {
        self.avatarAction(self.user.id ?? UUID())
    }
    
}
