//
//  UserProfileView.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import UIKit
import SnapKit

class UserProfileView: UIView {
    
    init(user: User, isAlienUser: Bool, editButtonAction: @escaping () -> Void, addPostButtonAction: @escaping () -> Void) {
        self.user = user
        self.editButtonAction = editButtonAction
        self.addPostButtonAction = addPostButtonAction
        self.isAlienUser = isAlienUser
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let editButtonAction: () -> Void
    private let addPostButtonAction: () -> Void
    private let isAlienUser: Bool
    private var user: User {
        didSet {
            self.avatarImageView.image = UIImage(data: Data(base64Encoded: self.user.image ?? (UIImage(named: "empty avatar")?.pngData()?.base64EncodedString() ?? "")) ?? Data())
            self.subscribersCountLabel.text = String(self.user.subscribers.count)
            self.subscribtionsCountLabel.text = String(self.user.subscribtions.count)
        }
    }
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "empty avatar")
        view.layer.borderColor = UIColor.boundsColor.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = view.frame.width / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .boldSystemFont(ofSize: 22)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let userWorkNameLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .systemGray
        view.font = .boldSystemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subscribersLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Subscribers", comment: "")
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subscribtionsLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Subscribers", comment: "")
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subscribersCountLabel: UILabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subscribtionsCountLabel: UILabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let editButton: UIButton = {
        let view = UIButton()
        
        view.setTitle("Let edit", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let addPostButton: UIButton = {
        let view = UIButton()
        
        view.setTitle("Add Post", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
        
        self.editButton.addTarget(self, action: #selector(self.editButtonDidTap), for: .touchUpInside)
        self.addPostButton.addTarget(self, action: #selector(self.addPostButtonDidTap), for: .touchUpInside)
        
        if isAlienUser {
            self.editButton.isHidden = true
            self.addPostButton.isHidden = true
        }
        
        self.addSubview(self.avatarImageView)
        self.addSubview(self.userNameLabel)
        self.addSubview(self.userWorkNameLabel)
        self.addSubview(self.subscribersLabel)
        self.addSubview(self.subscribtionsLabel)
        self.addSubview(self.subscribersCountLabel)
        self.addSubview(self.subscribtionsLabel)
        self.addSubview(self.editButton)
        self.addSubview(self.addPostButton)
        
        self.avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.25)
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView)
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
        }
        
        self.userWorkNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userNameLabel.snp.bottom).inset(-15)
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
        }
        
        self.subscribtionsLabel.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView.snp.bottom).inset(-25)
            make.centerX.equalToSuperview().multipliedBy(0.5)
        }
        
        self.subscribtionsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.subscribtionsLabel.snp.bottom).inset(-10)
            make.centerX.equalTo(self.subscribtionsLabel)
        }
        
        self.subscribersLabel.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView.snp.bottom).inset(-25)
            make.centerX.equalToSuperview().multipliedBy(1.5)
        }
        
        self.subscribersCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.subscribersLabel.snp.bottom).inset(-10)
            make.centerX.equalTo(self.subscribersLabel)
        }
        
        self.editButton.snp.makeConstraints { make in
            make.top.equalTo(self.subscribtionsCountLabel.snp.bottom).inset(-25)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        self.addPostButton.snp.makeConstraints { make in
            make.top.equalTo(self.editButton.snp.bottom).inset(-15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
    }
    
    @objc private func editButtonDidTap() {
        self.editButtonAction()
    }
    
    @objc private func addPostButtonDidTap() {
        self.addPostButtonAction()
    }

}
