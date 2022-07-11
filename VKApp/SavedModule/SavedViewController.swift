//
//  SavedViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 04.07.2022.
//

import UIKit
import SnapKit

final class SavedViewController: UIViewController {
    
    init(presenter: SavedPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: SavedPresenter
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let emptyLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("No saved posts", comment: "")
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 22)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.getPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.title = NSLocalizedString("Saved", comment: "")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellID)
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.emptyLabel)
        
        self.tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(self.tableView)
        }
    }

}

extension SavedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellID) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        cell.post = self.presenter.posts[indexPath.row].post
        cell.user = self.presenter.posts[indexPath.row].user
        cell.likeButtonIsSelected = true
        cell.dislikeAction = {  [ weak self ] post, user in
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
                self?.presenter.deletePost(post: post) {
                    self?.presenter.getPosts()
                }
            }
        }
        cell.commentAction = { post, user in
            // push comment view controller
        }
        cell.avatarAction = { [ weak self ] user in
            self?.presenter.goToProfile(userID: user.id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.presenter.posts.count
                
        if count == 0 {
            self.emptyLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.emptyLabel.isHidden = true
            self.tableView.isHidden = false
        }
        
        return count
    }
    
}

extension SavedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Saved Posts", comment: "") + ":"
    }
    
}
