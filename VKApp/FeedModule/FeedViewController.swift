//
//  FeedViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 05.07.2022.
//

import UIKit
import SnapKit

final class FeedViewController: UIViewController {
    
    init(presenter: FeedPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.tableView.reloadData() }
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
    
    private let refreshControll = UIRefreshControl()
    
    private let emptyLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("No new posts", comment: "")
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 22)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.getAllPosts { [ weak self ] error in
            switch error {
            case .statusCodeError(let number):
                self?.callAlert(title: "\(NSLocalizedString("Error", comment: "")) \(number ?? 500)", text: nil)
            case .decodeFailed:
                self?.callAlert(title: NSLocalizedString("Failed to get data", comment: ""), text: nil)
            default:
                self?.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
                
                break
            }
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.title = NSLocalizedString("Feed", comment: "")
        
        self.tableView.refreshControl = self.refreshControll
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellID)
        
        self.refreshControll.addTarget(self, action: #selector(self.pulledToRefresh), for: .valueChanged)
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.emptyLabel)
        
        self.tableView.addSubview(self.refreshControll)
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func pulledToRefresh() {
        if self.refreshControll.isRefreshing {
            self.presenter.getAllPosts { [ weak self ] error in
                self?.refreshControll.endRefreshing()
                
                switch error {
                case .statusCodeError(let number):
                    self?.callAlert(title: "\(NSLocalizedString("Error", comment: "")) \(number ?? 500)", text: nil)
                case .decodeFailed:
                    self?.callAlert(title: NSLocalizedString("Failed to get data", comment: ""), text: nil)
                default:
                    self?.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
                    
                    break
                }
            } didComplete: { [ weak self ] in
                self?.refreshControll.endRefreshing()
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
        cell.isProfilePost = false
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
        cell.dislikeAction = { [ weak self ] post, user in
            guard let id = post.id else {
                return
            }
            
            self?.presenter.dislike(postID: id) { error in
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
                self?.presenter.deletePost(post: post)
            }
        }
        cell.avatarAction = { [ weak self ] user in
            self?.presenter.getAllCoreDataUsers { users in
                self?.presenter.goToProfile(userID: user.id, isSubscribedUser: users.contains { $0.id == user.id })
            }
        }
        self.presenter.getAllCoreDataPosts { posts in
            if posts.contains(where: { $0.id == cell.post?.id }) {
                cell.likeButtonIsSelected = true
            }
        }
        cell.commentAction = { [ weak self ] cell in
            guard let post = cell.post,
                  let user = cell.user else {
                return
            }
            
            self?.presenter.goToComments(
                likeAction: cell.likeAction ?? { _, _ in },
                dislikeAction: cell.dislikeAction ?? { _, _ in },
                commentAction: { _ in },
                avatarAction: cell.avatarAction ?? { _ in },
                post: post,
                user: user,
                likeButtonIsSelected: cell.likeButtonIsSelected ?? false,
                frame: cell.frame
            )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.presenter.posts.count == 0 {
            self.tableView.isHidden = true
            self.emptyLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.emptyLabel.isHidden = true
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
