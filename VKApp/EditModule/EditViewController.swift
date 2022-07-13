//
//  EditViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 01.07.2022.
//

import UIKit
import SnapKit

final class EditViewController: UIViewController {
    
    init(presenter: EditPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: EditPresenter
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.allowsEditing = false
        view.sourceType = .photoLibrary
        
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "empty avatar"))
        
        view.layer.borderColor = UIColor.boundsColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 100
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .boldSystemFont(ofSize: 18)
        view.text = NSLocalizedString("Enter your name", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let workNameLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .boldSystemFont(ofSize: 18)
        view.text = NSLocalizedString("Enter your work name", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameTextField: UITextField = {
        let view = UITextField()
        
        view.backgroundColor = .textFieldColor
        view.tintColor = .systemOrange
        view.layer.borderColor = UIColor.boundsColor.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        view.placeholder = NSLocalizedString("Name", comment: "")
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let workNameTextField: UITextField = {
        let view = UITextField()
        
        view.backgroundColor = .textFieldColor
        view.tintColor = .systemOrange
        view.layer.borderColor = UIColor.boundsColor.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        view.placeholder = NSLocalizedString("Work name", comment: "")
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let saveButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .systemOrange
        view.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let logOutButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .systemRed
        view.setTitle(NSLocalizedString("Log Out", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let translucentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray
        view.alpha = 0.5
        view.isHidden = true
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboadWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.title = NSLocalizedString("Edit", comment: "")
        self.view.backgroundColor = .backgroundColor
        
        if let user = self.presenter.user {
            self.avatarImageView.image = UIImage(data: Data(base64Encoded: user.image ?? "") ?? Data())
            self.nameTextField.text = user.name
            self.workNameTextField.text = user.work
        }
        
        self.imagePickerController.delegate = self
        
        self.avatarImageView.isUserInteractionEnabled = true
        self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showImagePickerController)))
        
        self.saveButton.addTarget(self, action: #selector(self.editUser), for: .touchUpInside)
        self.logOutButton.addTarget(self, action: #selector(self.logOut), for: .touchUpInside)
        
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.translucentView)
        self.view.insertSubview(self.translucentView, at: 10)
        
        self.translucentView.addSubview(self.activityIndicatorView)
        
        self.scrollView.addSubview(self.avatarImageView)
        self.scrollView.addSubview(self.nameLabel)
        self.scrollView.addSubview(self.nameTextField)
        self.scrollView.addSubview(self.workNameLabel)
        self.scrollView.addSubview(self.workNameTextField)
        self.scrollView.addSubview(self.saveButton)
        self.scrollView.addSubview(self.logOutButton)
                
        self.scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.translucentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.avatarImageView.snp.bottom).inset(-15)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
        
        self.workNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameTextField.snp.bottom).inset(-15)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }
        
        self.workNameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.workNameLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.top.equalTo(self.workNameTextField.snp.bottom).inset(-25)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
            
            if self.presenter.isFirstEdit {
                self.logOutButton.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(15)
                }
            }
        }
        
        self.logOutButton.snp.makeConstraints { make in
            make.top.equalTo(self.saveButton.snp.bottom).inset(-25)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
            
            if !self.presenter.isFirstEdit {
                self.logOutButton.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(15)
                }
            }
        }
        
        if self.presenter.isFirstEdit {
            self.logOutButton.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
            
            self.saveButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(15)
            }
        } else {
            self.logOutButton.isHidden = false
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.title = nil
            
            self.logOutButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(15)
            }
        }
    }
    
    @objc private func editUser() {
        self.translucentView.isHidden = false
        self.activityIndicatorView.isHidden = false
        
        self.presenter.editUser(user: User(
            email: "",
            passwordHash: "",
            name: self.nameTextField.text ?? "",
            work: self.workNameTextField.text ?? "",
            image: self.avatarImageView.image?.pngData()?.base64EncodedString()
        )) {
            self.translucentView.isHidden = true
            self.activityIndicatorView.isHidden = true
            self.presenter.goToTabBar()
        } didNotComplete: { error in
            self.translucentView.isHidden = true
            self.activityIndicatorView.isHidden = true
            
            switch error {
            case .statusCodeError(let statusCode):
                self.callAlert(title: NSLocalizedString("Error", comment: "") + String(statusCode ?? 500), text: nil)
            case .encodeFailed:
                self.callAlert(title: NSLocalizedString("Error", comment: ""), text: NSLocalizedString("Incorrect data", comment: ""))
            default:
                self.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
                
                break
            }
        }
    }
    
    @objc private func logOut() {
        self.translucentView.isHidden = false
        self.activityIndicatorView.isHidden = false
        
        self.presenter.logOut {
            self.translucentView.isHidden = true
            self.activityIndicatorView.isHidden = true
            self.presenter.deleteKeychainData()
            self.presenter.goToOnboarding()
        } didNotComplete: { _ in
            self.translucentView.isHidden = true
            self.activityIndicatorView.isHidden = true
            self.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
        }

    }
    
    @objc private func showImagePickerController() {
        self.present(self.imagePickerController, animated: true)
    }
    
    @objc private func keyboadWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height,
                right: 0
            )
            scrollView.setContentOffset(CGPoint(x: 0, y: max(scrollView.contentSize.height - scrollView.bounds.size.height, 0) ), animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
}

extension EditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.originalImage] as? UIImage) {
            self.avatarImageView.image = image
            
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
