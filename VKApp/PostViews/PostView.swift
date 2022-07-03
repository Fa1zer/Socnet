//
//  PostTableViewCell.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 02.07.2022.
//

import UIKit
import SnapKit

class PostView: UIView {
    
    init(likeAction: @escaping (Post) -> Void, commentAction: @escaping (Post) -> Void, avatarAction: @escaping (UUID) -> Void, post: Post, user: User, isSelected: Bool) {
        self.likeAction = likeAction
        self.commentAction = commentAction
        self.avatarAction = avatarAction
        self.post = post
        self.user = user
        self.likeButtonIsSelected = isSelected
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let likeAction: (Post) -> Void
    private let commentAction: (Post) -> Void
    private let avatarAction: (UUID) -> Void
    private var post: Post {
        didSet {
            guard let imageData = Data(base64Encoded: self.post.image) else {
                return
            }
            
            self.postImageView.image = UIImage(data: imageData)
            self.textLabel.text = self.post.text
            self.likeCountLabel.text = String(self.post.likes)
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
    
    private var likeButtonIsSelected: Bool {
        didSet {
            if self.likeButtonIsSelected {
                self.likeButton.isSelected = true
            }
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
    
    private let postImageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let likeButton: UIButton = {
        let view = UIButton()
        let firstImage = UIImage(named: "heart")
        let secondImage = UIImage(named: "heart.fill")
        
        firstImage?.withTintColor(.textColor)
        secondImage?.withTintColor(.systemRed)
        
        view.setImage(firstImage, for: .normal)
        view.setImage(secondImage, for: .selected)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let likeCountLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let commentButton: UIButton = {
        let view = UIButton()
        
        view.setImage(UIImage(named: "bubble.right"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.likeButton.addTarget(self, action: #selector(self.likeButtonDidTap), for: .touchUpInside)
        self.commentButton.addTarget(self, action: #selector(self.commentButtonDidTap), for: .touchUpInside)
        self.userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarImageViewDidTap)))
        self.userNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarImageViewDidTap)))
        
        self.userAvatarImageView.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        
        self.addSubview(self.userAvatarImageView)
        self.addSubview(self.userNameLabel)
        self.addSubview(self.postImageView)
        self.addSubview(self.textLabel)
        self.addSubview(self.likeCountLabel)
        self.addSubview(self.likeButton)
        self.addSubview(self.commentButton)
        
        self.userAvatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(50)
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.userAvatarImageView)
            make.leading.equalTo(self.userAvatarImageView.snp.trailing).inset(-15)
        }
        
        self.postImageView.snp.makeConstraints { make in
            make.top.equalTo(self.userAvatarImageView.snp.bottom).inset(-15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.postImageView.snp.width)
        }
        
        self.textLabel.snp.makeConstraints { make in
            make.top.equalTo(self.postImageView.snp.bottom).inset(-25)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        self.likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.textLabel.snp.bottom).inset(-25)
            make.leading.equalToSuperview().inset(15)
        }
        
        self.likeButton.snp.makeConstraints { make in
            make.leading.equalTo(self.likeCountLabel.snp.trailing).inset(-10)
            make.centerY.equalTo(self.likeCountLabel)
            make.height.width.equalTo(30)
        }
        
        self.commentButton.snp.makeConstraints { make in
            make.leading.equalTo(self.likeButton.snp.trailing).inset(-25)
            make.centerY.equalTo(self.likeCountLabel)
            make.height.width.equalTo(30)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    @objc private func likeButtonDidTap() {
        self.post.likes += 1
        
        self.likeAction(self.post)
    }
    
    @objc private func commentButtonDidTap() {
        self.commentAction(self.post)
    }
    
    @objc private func avatarImageViewDidTap() {
        self.avatarAction(self.user.id ?? UUID())
    }

}
