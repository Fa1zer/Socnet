//
//  ProfileViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = self.tableView.reloadData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: ProfilePresenter
    
    private let refreshControll = UIRefreshControl()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.backgroundColor = .clear
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.presenter.isAlienUser {
            self.presenter.getSomeUser { [ weak self ] error in
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
        } else {
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
    }
    
    private func setupViews() {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.title = nil
        self.view.backgroundColor = .backgroundColor
        
        self.tableView.refreshControl = self.refreshControll
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellID)
        
        self.refreshControll.addTarget(self, action: #selector(self.pulledToRefresh), for: .valueChanged)
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicatorView)
        
        self.tableView.addSubview(self.refreshControll)
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func pulledToRefresh() {
        if self.refreshControll.isRefreshing {
            if self.presenter.isAlienUser {
                self.presenter.getSomeUser { [ weak self ] error in
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
            } else {
                self.presenter.getUser { [ weak self ] error in
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

}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellID) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        cell.user = self.presenter.user
        cell.post = self.presenter.posts[indexPath.row]
        cell.likeButtonIsSelected = false
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
        cell.dislikeAction = { [ weak self ] post, _ in
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
        if self.presenter.user == nil {
            self.tableView.isHidden = true
            self.activityIndicatorView.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.activityIndicatorView.isHidden = true
        }
        
        return self.presenter.posts.count
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let user = self.presenter.user else {
            return nil
        }
        
        return UserProfileView(user: user, isAlienUser: self.presenter.isAlienUser, isSubscribedUser: self.presenter.isSubscribedUser) {
            self.presenter.goToEdit()
        } addPostButtonAction: { [ weak self ] in
            self?.presenter.goToCreatePost()
        } subscriberSubscriptionsAction: { [ weak self ] usersId in
            // push find view controller
        } subscribeAction: { [ weak self ] user in
            self?.presenter.subscribe(userID: user.id ?? UUID()) { error in
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
                self?.presenter.saveUser(user: user)
            }
        } unsubscribeAction: { [ weak self ] user in
            self?.presenter.unsubscribe(userID: user.id ?? UUID()) { error in
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
                self?.presenter.deleteUser(user: user)
            }

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (self.view.frame.width / 4) + 340
    }
    
}
