//
//  UserProfileView.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import UIKit
import SnapKit

final class UserProfileView: UIView {
    
    init(user: User, isAlienUser: Bool, isSubscribedUser: Bool, editButtonAction: @escaping () -> Void, addPostButtonAction: @escaping () -> Void, subscribersAction: @escaping (UUID) -> Void, subscribeAction: @escaping (User) -> Void, unsubscribeAction: @escaping (User) -> Void, subscribtionsAction: @escaping (UUID) -> Void) {
        self.user = user
        self.editButtonAction = editButtonAction
        self.addPostButtonAction = addPostButtonAction
        self.subscribersAction = subscribersAction
        self.subscribtionsAction = subscribtionsAction
        self.isAlienUser = isAlienUser
        self.subscribeAction = subscribeAction
        self.unsubscribeAction = unsubscribeAction
        self.isSubscribedUser = isSubscribedUser
        
        super.init(frame: .zero)
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
        self.avatarImageView.image = UIImage(data: Data(base64Encoded: self.user.image ?? (UIImage(named: "empty avatar")?.pngData()?.base64EncodedString() ?? "")) ?? Data())
        self.userNameLabel.text = self.user.name
        self.userWorkNameLabel.text = self.user.work
        self.subscribersCountLabel.text = String(self.user.subscribers.count)
        self.subscribtionsCountLabel.text = String(self.user.subscribtions.count)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let editButtonAction: () -> Void
    private let addPostButtonAction: () -> Void
    private let subscribersAction: (UUID) -> Void
    private let subscribtionsAction: (UUID) -> Void
    private let subscribeAction: (User) -> Void
    private let unsubscribeAction: (User) -> Void
    private let isAlienUser: Bool
    private var isSubscribedUser: Bool
    private var user: User
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "empty avatar")
        view.layer.cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
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
        
        view.text = NSLocalizedString("Subscribtions", comment: "")
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subscribersCountLabel: UILabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .textColor
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subscribtionsCountLabel: UILabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .textColor
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let editButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("Let edit", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let addPostButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("Add Post", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subscribeButton: UIButton = {
        let view = UIButton()
        
        view.isHidden = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .backgroundColor
        
        self.editButton.addTarget(self, action: #selector(self.editButtonDidTap), for: .touchUpInside)
        self.addPostButton.addTarget(self, action: #selector(self.addPostButtonDidTap), for: .touchUpInside)
        self.subscribeButton.addTarget(self, action: #selector(self.subscribeButtonDidTap), for: .touchUpInside)
        
        self.subscribtionsCountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSubscriptions)))
        self.subscribtionsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSubscriptions)))
        self.subscribersCountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSubscribers)))
        self.subscribersLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goToSubscribers)))
        self.subscribtionsCountLabel.isUserInteractionEnabled = true
        self.subscribtionsLabel.isUserInteractionEnabled = true
        self.subscribersCountLabel.isUserInteractionEnabled = true
        self.subscribersLabel.isUserInteractionEnabled = true
        
        if self.isAlienUser {
            self.editButton.isHidden = true
            self.addPostButton.isHidden = true
            self.subscribeButton.isHidden = false
        }
        
        if self.isSubscribedUser {
            self.subscribeButton.setTitle(NSLocalizedString("Unsubscribe", comment: ""), for: .normal)
            self.subscribeButton.setTitleColor(.black, for: .normal)
            self.subscribeButton.backgroundColor = .systemGray
        } else {
            self.subscribeButton.setTitle(NSLocalizedString("Subscribe", comment: ""), for: .normal)
            self.subscribeButton.setTitleColor(.white, for: .normal)
            self.subscribeButton.backgroundColor = .systemOrange
        }
        
        self.addSubview(self.avatarImageView)
        self.addSubview(self.userNameLabel)
        self.addSubview(self.userWorkNameLabel)
        self.addSubview(self.subscribersLabel)
        self.addSubview(self.subscribtionsLabel)
        self.addSubview(self.editButton)
        self.addSubview(self.addPostButton)
        self.addSubview(self.subscribersCountLabel)
        self.addSubview(self.subscribtionsCountLabel)
        self.addSubview(self.subscribeButton)
        
        self.avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.height.width.equalTo(self.snp.width).multipliedBy(0.25)
        }
        
        self.userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView).inset(15)
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
            make.leading.trailing.centerX.equalTo(self.subscribtionsLabel)
        }
        
        self.subscribersLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.subscribtionsLabel)
            make.centerX.equalToSuperview().multipliedBy(1.5)
        }
        
        self.subscribersCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.subscribtionsCountLabel)
            make.leading.trailing.centerX.equalTo(self.subscribersLabel)
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
        
        self.subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(self.addPostButton.snp.bottom).inset(-15)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
    }
    
    @objc private func editButtonDidTap() {
        self.editButtonAction()
    }
    
    @objc private func addPostButtonDidTap() {
        self.addPostButtonAction()
    }
    
    @objc private func goToSubscriptions() {
        guard let id = self.user.id else {
            return
        }
        
        self.subscribtionsAction(id)
    }
    
    @objc private func goToSubscribers() {
        guard let id = self.user.id else {
            return
        }
        
        self.subscribersAction(id)
    }
    
    @objc private func subscribeButtonDidTap() {
        if self.isSubscribedUser {
            self.isSubscribedUser = false
            self.subscribeButton.setTitle(NSLocalizedString("Subscribe", comment: ""), for: .normal)
            self.subscribeButton.setTitleColor(.white, for: .normal)
            self.subscribeButton.backgroundColor = .systemOrange
            self.subscribersCountLabel.text = "\((Int(self.subscribersCountLabel.text ?? "1") ?? 1) - 1)"
            self.layoutSubviews()
            
            self.unsubscribeAction(user)
        } else {
            self.isSubscribedUser = true
            self.subscribeButton.setTitle(NSLocalizedString("Unsubscribe", comment: ""), for: .normal)
            self.subscribeButton.setTitleColor(.black, for: .normal)
            self.subscribeButton.backgroundColor = .systemGray
            self.subscribersCountLabel.text = "\((Int(self.subscribersCountLabel.text ?? "1") ?? 1) + 1)"
            
            self.subscribeAction(user)
        }
    }
    
    @objc private func unsubscribeButtonDidTap() {
        self.unsubscribeAction(user)
    }

}
