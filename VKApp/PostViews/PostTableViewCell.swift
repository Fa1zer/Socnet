//
//  PostTableViewCell.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 03.07.2022.
//

import UIKit
import SnapKit

class PostTableViewCell: UITableViewCell {
    
    init(likeAction: @escaping (Post) -> Void, commentAction: @escaping (Post) -> Void, avatarAction: @escaping (UUID) -> Void, post: Post, user: User, isSelected: Bool) {
        self.likeAction = likeAction
        self.commentAction = commentAction
        self.post = post
        self.user = user
        self.likeButtonIsSelected = isSelected
        
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let likeAction: (Post) -> Void
    private let commentAction: (Post) -> Void
    private let avatarAction: (UUID) -> Void
    private let post: Post
    private let user: User
    private let likeButtonIsSelected: Bool
    
    private var postView: PostView { PostView(
        likeAction: self.likeAction,
        commentAction: self.commentAction,
        avatarAction: self.avatarAction,
        post: self.post,
        user: self.user,
        isSelected: self.likeButtonIsSelected
    ) }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.commentAction(self.post)
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.postView)
        
        self.postView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
