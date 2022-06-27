//
//  CustomUIViewController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 27.06.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func callAlert(title: String, text: String?) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
    
    func callTwoActionsAlert(title: String, text: String?, firstAction: @escaping () -> Void, secondAction: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let firstAlertAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .cancel, handler: { _ in firstAction() })
        let secondAlertAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: { _ in secondAction() })
        
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        
        self.present(alertController, animated: true)
    }
    
}
