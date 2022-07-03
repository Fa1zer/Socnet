//
//  PostTableViewHeaderFooterView.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 03.07.2022.
//

import UIKit
import SnapKit

class PostTableViewHeaderFooterView: UITableViewHeaderFooterView {

    init(likeAction: @escaping (Post) -> Void, avatarAction: @escaping (UUID) -> Void, post: Post, user: User, isSelected: Bool) {
        self.likeAction = likeAction
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
    private let avatarAction: (UUID) -> Void
    private let post: Post
    private let user: User
    private let likeButtonIsSelected: Bool
    
    private var postView: PostView { PostView(
        likeAction: self.likeAction,
        commentAction: { _ in },
        avatarAction: self.avatarAction,
        post: self.post,
        user: self.user,
        isSelected: self.likeButtonIsSelected
    ) }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.postView)
        
        self.postView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
