//
//  CreatePostViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 11.07.2022.
//

import UIKit
import SnapKit

final class CreatePostViewController: UIViewController {
    
    init(presenter: CreatePostPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: CreatePostPresenter
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "empty avatar"))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let textView: UITextView = {
        let view = UITextView()
        
        view.backgroundColor = .clear
        view.textColor = .textColor
        view.tintColor = .systemOrange
        view.layer.borderColor = UIColor.boundsColor.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let saveButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .systemOrange
        view.setTitle(NSLocalizedString("Publish Post", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.allowsEditing = false
        view.sourceType = .photoLibrary
        
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .backgroundColor
        self.title = NSLocalizedString("New Post", comment: "")
        
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(self.showImagePickerController)
        ))
        self.imageView.isUserInteractionEnabled = true
        
        self.saveButton.addTarget(self, action: #selector(self.saveButtonDidTap), for: .touchUpInside)
        
        self.imagePickerController.delegate = self
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addSubview(self.textView)
        self.scrollView.addSubview(self.saveButton)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalToSuperview()
        }
        
        self.imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(self.imageView.snp.width)
        }
        
        self.textView.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp.bottom).inset(-15)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(200)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.top.equalTo(self.textView.snp.bottom).inset(-15)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
    }
    
    @objc private func saveButtonDidTap() {
        self.presenter.createPost(post: Post(
            userID: self.presenter.userID,
            image: self.imageView.image?.pngData()?.base64EncodedString() ?? "",
            text: self.textView.text
        )) { [ weak self ] error in
            switch error {
            case .statusCodeError(let number):
                self?.callAlert(title: "\(NSLocalizedString("Error", comment: "")) \(number ?? 500)", text: nil)
            case .decodeFailed:
                self?.callAlert(title: NSLocalizedString("Failed to send data", comment: ""), text: nil)
            default:
                self?.callAlert(title: NSLocalizedString("Error", comment: ""), text: nil)
                
                break
            }
        } didComplete: { [ weak self ] in
            self?.presenter.goToProfile()
        }
    }
    
    @objc private func showImagePickerController() {
        self.present(self.imagePickerController, animated: true)
    }
    
    @objc private func keyboadWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.contentInset.bottom = keyboardSize.height
            self.scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height,
                right: 0
            )
            self.scrollView.setContentOffset(CGPoint(x: 0, y: max(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0) ), animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset.bottom = .zero
        self.scrollView.verticalScrollIndicatorInsets = .zero
    }

}

extension CreatePostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.originalImage] as? UIImage) {
            self.imageView.image = image
            
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
