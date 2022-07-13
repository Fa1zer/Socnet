//
//  PostTableViewCell.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 02.07.2022.
//

import UIKit
import SnapKit

final class PostTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var likeAction: ((Post, User) -> Void)?
    var dislikeAction: ((Post, User) -> Void)?
    var commentAction: ((PostTableViewCell) -> Void)?
    var avatarAction: ((User) -> Void)?
    var post: Post? {
        didSet {
            guard let imageData = Data(base64Encoded: self.post?.image ?? "") else {
                return
            }
            
            self.postImageView.image = UIImage(data: imageData)
            self.postTextLabel.text = self.post?.text ?? ""
            
            if self.post?.likes != -1 {
                self.likeCountLabel.text = String.localizedStringWithFormat(
                    NSLocalizedString("likes", comment: ""),
                    UInt(self.post?.likes ?? 0)
                )
            } else {
                self.likeCountLabel.isHidden = true
            }
        }
    }
    
    var user: User? {
        didSet {
            guard let imageString = self.user?.image,
                  let dataImage = Data(base64Encoded: imageString) else {
                return
            }
            
            self.userAvatarImageView.image = UIImage(data: dataImage)
            self.userNameLabel.text = self.user?.name ?? ""
        }
    }
    
    var likeButtonIsSelected: Bool? {
        didSet {
            if self.likeButtonIsSelected ?? false {
                self.likeButton.isSelected = true
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
                self.likeButton.tintColor = .systemRed
            } else {
                self.likeButton.isSelected = true
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .selected)
                self.likeButton.tintColor = .textColor
            }
        }
    }
    
    static let cellID = "post"
    
    private let userAvatarImageView: UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
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
        
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let postTextLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let likeButton: UIButton = {
        let view = UIButton()
        
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .textColor
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
        
        view.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        view.tintColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.commentButtonDidTap()
            self.setSelected(false, animated: true)
        }
    }
    
    private func setupViews() {
        self.backgroundColor = .backgroundColor
        
        self.likeButton.addTarget(self, action: #selector(self.likeButtonDidTap), for: .touchUpInside)
        self.commentButton.addTarget(self, action: #selector(self.commentButtonDidTap), for: .touchUpInside)
        self.userAvatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarImageViewDidTap)))
        self.userNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarImageViewDidTap)))
        
        self.userAvatarImageView.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        
        self.contentView.addSubview(self.userAvatarImageView)
        self.contentView.addSubview(self.userNameLabel)
        self.contentView.addSubview(self.postImageView)
        self.contentView.addSubview(self.postTextLabel)
        self.contentView.addSubview(self.likeCountLabel)
        self.contentView.addSubview(self.likeButton)
        self.contentView.addSubview(self.commentButton)

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

        self.postTextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.postImageView.snp.bottom).inset(-25)
            make.leading.trailing.equalToSuperview().inset(15)
        }

        self.likeCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.likeButton)
            make.trailing.equalToSuperview().inset(15)
        }

        self.likeButton.snp.makeConstraints { make in
            make.top.equalTo(self.postTextLabel.snp.bottom).inset(-25)
            make.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }

        self.commentButton.snp.makeConstraints { make in
            make.top.equalTo(self.postTextLabel.snp.bottom).inset(-25)
            make.leading.equalTo(self.likeButton.snp.trailing).inset(-15)
            make.bottom.equalToSuperview().inset(15)
        }

        self.likeButton.imageView?.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }

        self.commentButton.imageView?.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
    }
    
    @objc private func likeButtonDidTap() {
        if !(self.likeButtonIsSelected ?? true) {
            self.post?.likes += 1
            self.likeButtonIsSelected = true
            
            guard let post = self.post,
                  let user = self.user else {
                return
            }
            
            self.likeAction?(post, user)
        } else {
            if self.likeAction != nil {
                self.post?.likes -= 1
            }
            
            self.likeButtonIsSelected = false
            
            guard let post = self.post,
                  let user = self.user else {
                return
            }
            
            self.dislikeAction?(post, user)
        }
    }
    
    @objc private func commentButtonDidTap() {
        self.commentAction?(self)
    }
    
    @objc private func avatarImageViewDidTap() {
        guard let user = user else {
            return
        }

        
        self.avatarAction?(user)
    }

}
