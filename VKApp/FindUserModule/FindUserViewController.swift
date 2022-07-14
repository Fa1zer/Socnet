//
//  FindUserViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 13.07.2022.
//

import UIKit
import SnapKit

final class FindUserViewController: UIViewController {
    
    init(presenter: FindUserPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.tableView.reloadData() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let presenter: FindUserPresenter
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let emptyLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("No users", comment: "")
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 18)
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
        
        switch self.presenter.mode {
        case .subscriptions:
            self.presenter.getUsers()
            self.presenter.getUserSubscribtions { [ weak self ] error in
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
        case .subscribers:
            self.presenter.getUsers()
            self.presenter.getUserSubscribers { [ weak self ] error in
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
        case .coreDataSubscriptions:
            self.presenter.getUsers()
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.title = nil
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.cellID)
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.emptyLabel)
        
        self.tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        self.emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

extension FindUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.presenter.usersEntity.isEmpty && self.presenter.users.isEmpty {
            self.emptyLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.emptyLabel.isHidden = true
            self.tableView.isHidden = false
        }
        
        if self.presenter.mode == .coreDataSubscriptions {
            return self.presenter.usersEntity.count
        }
                
        return self.presenter.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellID) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        if self.presenter.mode == .coreDataSubscriptions {
            let user = self.presenter.usersEntity[indexPath.row]
            
            cell.user = User(
                id: user.id,
                email: "",
                passwordHash: "",
                name: user.name ?? "",
                work: user.work ?? "",
                image: user.image?.base64EncodedString() ?? (UIImage(named: "empty avatar")?.pngData()?.base64EncodedString() ?? "")
            )
            cell.didTapAction = { [ weak self ] userID in
                self?.presenter.goToProfile(userID: userID, isSubscribedUser: true)
            }
            
            return cell
        }
        
        cell.user = self.presenter.users[indexPath.row]
        cell.didTapAction = { [ weak self ] userID in
            self?.presenter.goToProfile(userID: userID, isSubscribedUser: self?.presenter.usersEntity.contains { $0.id == userID } ?? false)
        }
        
        return cell
    }
    
}

extension FindUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
