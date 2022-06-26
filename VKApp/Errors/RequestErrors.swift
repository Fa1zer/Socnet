//
//  RequestErrors.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 25.06.2022.
//

import Foundation

enum RequestErrors: Error {
    case badURL, notFound, decodeFailed, encodeFailed, dataError, tooMuchTime
}
