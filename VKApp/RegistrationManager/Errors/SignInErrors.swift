//
//  SignInErrors.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 26.06.2022.
//

import Foundation

enum SignInErrors: Error {
    case passwordTooShort, emailNotFound, someError(Error?), requestError(RequestErrors)
}
