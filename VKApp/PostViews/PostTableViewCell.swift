//
//  PostTableViewCell.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 03.07.2022.
//

import UIKit
import SnapKit

class PostTableViewCell: UITableViewCell {
    
    static let cellID = "post"
    
    var likeAction: ((Post) -> Void)?
    var commentAction: ((Post) -> Void)?
    var avatarAction: ((UUID) -> Void)?
    var post: Post?
    var user: User?
    var likeButtonIsSelected: Bool?
    
    private var postView: PostView {
        let view = PostView()
        
        view.post = self.post
        view.user = self.user
        view.avatarAction = self.avatarAction
        view.commentAction = self.commentAction
        view.likeAction = self.likeAction
        view.likeButtonIsSelected = self.likeButtonIsSelected
        
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.commentAction?(self.post ?? Post(userID: UUID(), image: ""))
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.postView)
        
        self.postView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
