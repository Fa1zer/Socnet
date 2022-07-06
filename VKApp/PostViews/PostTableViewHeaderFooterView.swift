//
//  PostTableViewHeaderFooterView.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 03.07.2022.
//

import UIKit
import SnapKit

class PostTableViewHeaderFooterView: UITableViewHeaderFooterView {

    var likeAction: ((Post) -> Void)?
    var avatarAction: ((UUID) -> Void)?
    var post: Post?
    var user: User?
    var likeButtonIsSelected: Bool?
    
    private var postView: PostView {
        let view = PostView()
        
        view.post = self.post
        view.user = self.user
        view.avatarAction = self.avatarAction
        view.likeAction = self.likeAction
        view.likeButtonIsSelected = self.likeButtonIsSelected
        
        return view
    }
    
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
