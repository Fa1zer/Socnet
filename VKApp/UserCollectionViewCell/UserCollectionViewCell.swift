//
//  UserCollectionViewCell.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 10.07.2022.
//

import UIKit
import SnapKit

final class UserCollectionViewCell: UICollectionViewCell {
    
    init() {
        super.init(frame: .zero)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var user: UserEntity?
    static let cellID = "UserCollectionViewCell"
    
    private let userImageView: UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func setupViews() {
        self.userImageView.image = UIImage(data: self.user?.image ?? Data())
        
        self.contentView.addSubview(self.userImageView)
        
        self.userImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.width.equalTo(65)
        }
    }
    
}
