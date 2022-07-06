//
//  FeedViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 05.07.2022.
//

import UIKit
import SnapKit

class FeedViewController: UIViewController {
    
    init(presenter: FeedPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.tableView.reloadData() }
        self.getAllPosts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: FeedPresenter
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.isHidden = true
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.title = NSLocalizedString("Feed", comment: "")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellID)
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicator)
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func getAllPosts() {
        self.presenter.getAllPosts { error in
            switch error {
            case .statusCodeError(let number):
                self.callAlert(title: "\(NSLocalizedString("Error", comment: "")) \(number ?? 500))", text: nil)
            case .decodeFailed:
                self.callAlert(title: NSLocalizedString("Failed to get data", comment: ""), text: nil)
            default:
                self.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
                
                break
            }
        }
    }

}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellID) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        cell.user = self.presenter.posts[indexPath.row].user
        cell.post = self.presenter.posts[indexPath.row].post
        cell.likeButtonIsSelected = false
        cell.commentAction = { post, user in
            // push comment view controller
        }
        cell.likeAction = { [ weak self ] post, user in
            self?.presenter.save(post: post, user: user)
        }
        cell.avatarAction = { user in
            // push profile view controller
        }
        
        self.presenter.getAllCoreDataPosts { posts in
            if posts.contains(where: { $0.id == cell.post?.id }) {
                cell.likeButtonIsSelected = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.presenter.posts.count == 0 {
            self.tableView.isHidden = true
            self.activityIndicator.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.activityIndicator.isHidden = true
        }
        
        return self.presenter.posts.count
    }
    
}

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("New Posts", comment: "") + ":"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
