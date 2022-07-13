//
//  UserTableViewCell.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 03.07.2022.
//

import UIKit
import SnapKit

final class UserTableViewCell: UITableViewCell {
    
    init(user: User, didTapAction: @escaping (UUID) -> Void) {
        self.user = user
        self.didTapAction = didTapAction
        
        super.init(style: .default, reuseIdentifier: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let didTapAction: (UUID) -> Void
    private var user: User {
        didSet {
            guard let imageString = self.user.image,
                  let dataImage = Data(base64Encoded: imageString) else {
                return
            }
            
            self.userAvatarImageView.image = UIImage(data: dataImage)
            self.userNameLabel.text = self.user.name
            self.userWorkNameLabel.text = self.user.work
        }
    }
    
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
    
    private let userWorkNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemGray
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.didTapAction(self.user.id ?? UUID())
    }
    
    private func setupViews() {
        self.backgroundColor = .backgroundColor
        
        self.contentView.addSubview(self.userAvatarImageView)
        self.contentView.addSubview(self.userNameLabel)
        self.contentView.addSubview(self.userWorkNameLabel)
        
        self.userAvatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(30)
            make.bottom.equalToSuperview().inset(15)
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalTo(self.userAvatarImageView.snp.trailing).inset(-10)
        }
        
        self.userWorkNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userNameLabel.snp.bottom).inset(-10)
            make.leading.equalTo(self.userAvatarImageView.snp.trailing).inset(-10)
        }
    }

}
