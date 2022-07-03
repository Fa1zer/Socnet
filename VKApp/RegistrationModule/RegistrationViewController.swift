//
//  RegistrationViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 27.06.2022.
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {
    
    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: RegistrationPresenter
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .systemOrange
        view.font = .boldSystemFont(ofSize: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let emailTextField: UITextField = {
        let view = UITextField()
         
        view.tintColor = .systemOrange
        view.textColor = .textColor
        view.font = UIFont.systemFont(ofSize: 16)
        view.autocapitalizationType = .none
        view.backgroundColor = .textFieldColor
        view.placeholder = "Email"
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
         
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let view = UITextField()
         
        view.tintColor = .systemOrange
        view.textColor = .textColor
        view.font = UIFont.systemFont(ofSize: 16)
        view.autocapitalizationType = .none
        view.backgroundColor = .textFieldColor
        view.isSecureTextEntry = true
        view.placeholder = NSLocalizedString("Password", comment: "")
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
         
        return view
    }()
    
    private let registrationButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .systemOrange
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboadWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        
        if self.presenter.registrationMode == .logIn {
            self.titleLabel.text = NSLocalizedString("Log In Title", comment: "")
            self.registrationButton.setTitle(NSLocalizedString("Log In", comment: ""), for: .normal)
            self.registrationButton.addTarget(self, action: #selector(self.logIn), for: .touchUpInside)
        } else {
            self.titleLabel.text = NSLocalizedString("Sign In Title", comment: "")
            self.registrationButton.setTitle(NSLocalizedString("Sign In", comment: ""), for: .normal)
            self.registrationButton.addTarget(self, action: #selector(self.signIn), for: .touchUpInside)
        }
        
        self.view.addSubview(scrollView)
        
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.emailTextField)
        self.scrollView.addSubview(self.passwordTextField)
        self.scrollView.addSubview(self.registrationButton)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        self.emailTextField.snp.makeConstraints { make in
            make.bottom.equalTo(self.scrollView.snp.centerY)
            make.leading.trailing.equalTo(self.view).inset(15)
            make.height.equalTo(50)
        }
        
        self.passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.snp.centerY)
            make.leading.trailing.equalTo(self.view).inset(15)
            make.height.equalTo(50)
        }
        
        self.registrationButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).inset(-15)
            make.leading.trailing.equalTo(self.view).inset(15)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(25)
        }
    }
    
    @objc private func logIn() {
        self.presenter.logIn(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { error in
            switch error {
            case .emailNotFound:
                self.callAlert(title: NSLocalizedString("Email is not valid", comment: ""), text: nil)
            case .passwordTooShort:
                self.callAlert(title: NSLocalizedString("Password is too short", comment: ""), text: NSLocalizedString("Password must contain at least 8 characters", comment: ""))
            default:
                self.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
            }
        } didComplete: {
            self.signIn()
        }
    }
    
    @objc private func signIn() {
        self.presenter.signIn(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { error in
            switch error {
            case .emailNotFound:
                self.callAlert(title: NSLocalizedString("Email is not valid", comment: ""), text: nil)
            case .passwordTooShort:
                self.callAlert(title: NSLocalizedString("Password is too short", comment: ""), text: NSLocalizedString("Password must contain at least 8 characters", comment: ""))
            default:
                self.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
            }
        } didComplete: {
            
            if self.presenter.registrationMode == .sigIn {
                self.presenter.goToTabBar()
            } else {
                self.presenter.goToEdit()
            }
        }
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
