//
//  CreateCommentView.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 12.07.2022.
//

import UIKit
import SnapKit

final class CreateCommentView: UIView {
    
    init(sendAction: @escaping (String) -> Void) {
        self.sendAction = sendAction
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let sendAction: (String) -> Void
    
    private let textField: UITextField = {
        let view = UITextField()
        
        view.backgroundColor = .textFieldColor
        view.textColor = .textColor
        view.tintColor = .systemOrange
        view.placeholder = NSLocalizedString("New message", comment: "")
        view.layer.borderColor = UIColor.boundsColor.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 25
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let sendButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .systemOrange
        view.setImage(UIImage(systemName: "paperplane"), for: .normal)
        view.tintColor = .white
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .backgroundColor
        
        self.sendButton.addTarget(self, action: #selector(self.sendButtonDidTap), for: .touchUpInside)
        
        self.addSubview(self.textField)
        self.addSubview(self.sendButton)
        
        self.textField.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(15)
            make.trailing.equalTo(self.sendButton.snp.leading).inset(-15)
        }
        
        self.sendButton.snp.makeConstraints { make in
            make.trailing.bottom.top.equalToSuperview().inset(15)
            make.height.width.equalTo(50)
        }
    }
    
    @objc private func sendButtonDidTap() {
        guard (self.textField.text?.count ?? 0) > 0 else {
            return
        }
        
        self.sendAction(self.textField.text ?? "")
    }

}
