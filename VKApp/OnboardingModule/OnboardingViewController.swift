//
//  OnboardingViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 28.06.2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    init(presenter: OnboardingPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: OnboardingPresenter
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "big logo"))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let logInButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("LOG IN", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let signInButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("I have an account", comment: ""), for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.signIn(didComplete: self.presenter.goToTabBar)
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        
        self.logInButton.addTarget(self, action: #selector(self.goToLogIn), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(self.goToSignIn), for: .touchUpInside)
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.logInButton)
        self.scrollView.addSubview(self.signInButton)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        self.logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(113)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(self.logoImageView.snp.width)
        }
        
        self.logInButton.snp.makeConstraints { make in
            make.top.equalTo(self.logoImageView.snp.bottom).inset(-90)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
        
        self.signInButton.snp.makeConstraints { make in
            make.top.equalTo(self.logInButton.snp.bottom).inset(-15)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(25)
        }
    }
    
    @objc private func goToLogIn() {
        self.presenter.goToLogIn()
    }
    
    @objc private func goToSignIn() {
        self.presenter.goToSignIn()
    }

}
