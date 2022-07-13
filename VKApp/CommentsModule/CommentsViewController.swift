//
//  CommentsViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 12.07.2022.
//

import UIKit
import SnapKit

final class CommentsViewController: UIViewController {
    
    init(presenter: CommentsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.tableView.reloadData() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: CommentsPresenter
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = self.presenter.post.id else {
            return
        }
        
        self.presenter.getComments(postID: id) { [ weak self ] error in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.title = nil
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.cellID)
        
        let view = CreateCommentView { text in
            guard let (image, name, stringID) = self.presenter.getUserData(),
            let postID = self.presenter.post.id,
            let userID = UUID(uuidString: stringID) else {
                return
            }
            
            let comment = Comment(userID: userID, postID: postID, text: text)
            
            self.presenter.createComment(comment: comment) { [ weak self ] error in
                switch error {
                case .statusCodeError(let number):
                    self?.callAlert(title: "\(NSLocalizedString("Error", comment: "")) \(number ?? 500)", text: nil)
                case .decodeFailed:
                    self?.callAlert(title: NSLocalizedString("Failed to get data", comment: ""), text: nil)
                default:
                    self?.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
                    
                    break
                }
            } didComplete: {
                self.presenter.comments.append((
                    comment: comment,
                    user: User(id: userID, email: "", passwordHash: "", name: name, image: image)
                ))
            }
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(view)
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.snp.top)
        }
        
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

}


extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return self.presenter.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.cellID) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.user = self.presenter.comments[indexPath.row].user
        cell.comment = self.presenter.comments[indexPath.row].comment
        cell.avatarAction = { [ weak self ] id in
            self?.presenter.getUsers { users in
                self?.presenter.geToProfile(userID: id, isSubscribedUser: users.contains { $0.id == id })
            }
        }
        
        return cell
    }
    
}

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = PostTableViewCell()
        
        cell.user = self.presenter.user
        cell.post = self.presenter.post
        cell.likeAction = self.presenter.likeAction
        cell.avatarAction = self.presenter.avatarAction
        cell.commentAction = self.presenter.commentAction
        cell.dislikeAction = self.presenter.dislikeAction
        cell.likeButtonIsSelected = self.presenter.likeButtonIsSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.presenter.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
