//
//  Service.swift
//  VKServices
//
//  Created by Dinar Garaev on 13.07.2022.
//

import Foundation

/// Модель сервиса
struct Service: Codable {
    let name: String
    let description: String
    let link: String
    let icon_url: String
}
