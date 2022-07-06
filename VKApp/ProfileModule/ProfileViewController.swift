//
//  ProfileViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = self.tableView.reloadData
        self.presenter.getUser { [ weak self ] error in
            switch error {
            case .statusCodeError(let number):
                self?.callAlert(title: "\(NSLocalizedString("Error", comment: "")) \(number ?? 500)", text: nil)
            case .decodeFailed:
                self?.callAlert(title: NSLocalizedString("Failed to send data", comment: ""), text: nil)
            default:
                self?.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
                
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: ProfilePresenter
    
    private let userIDLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .boldSystemFont(ofSize: 22)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.startAnimating()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellID)
        
        if let id = self.presenter.user?.id {
            self.userIDLabel.text = "@\(id)"
        }
        
        self.view.addSubview(self.userIDLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicatorView)
        
        self.userIDLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.view).inset(15)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellID) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        cell.user = self.presenter.user
        cell.post = self.presenter.posts[indexPath.row]
        cell.likeButtonIsSelected = false
        cell.commentAction = { post, user in
            // push comment view controller
        }
        cell.likeAction = { [ weak self ] post, user in
            guard let id = post.id else {
                return
            }
            
            self?.presenter.like(postID: id) { error in
                switch error {
                case .statusCodeError(let number):
                    self?.callAlert(title: "\(NSLocalizedString("Error", comment: "")) \(number ?? 500)", text: nil)
                case .decodeFailed:
                    self?.callAlert(title: NSLocalizedString("Failed to send data", comment: ""), text: nil)
                default:
                    self?.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
                    
                    break
                }
            } didComplete: {
                self?.presenter.save(post: post, user: user)
            }
        }
        self.presenter.getAllCoreDataPosts { posts in
            if posts.contains(where: { $0.id == cell.post?.id }) {
                cell.likeButtonIsSelected = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.presenter.user == nil {
            self.tableView.isHidden = true
            self.activityIndicatorView.isHidden = false
            self.userIDLabel.isHidden = true
        } else {
            self.tableView.isHidden = false
            self.activityIndicatorView.isHidden = true
            self.userIDLabel.isHidden = false
            self.userIDLabel.text = "@\(self.presenter.user?.id ?? UUID())"
        }
        
        return self.presenter.posts.count
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let user = self.presenter.user else {
            return nil
        }
        
        return UserProfileView(user: user, isAlienUser: self.presenter.isAlienUser) {
            self.presenter.goToEdit()
        } addPostButtonAction: {
            // push add post controller
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
