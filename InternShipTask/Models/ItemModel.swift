//
//  ItemModel.swift
//  InternShipTask
//
//  Created by ARMBP on 8/26/23.
//


import Foundation

struct ItemsResponse: Codable, Hashable{
    let advertisements: [ItemModel]
}

struct ItemModel: Codable, Hashable{
    let uuid = UUID()
    private enum CodingKeys : String, CodingKey { case id, title, price, location, imageUrl, createdDate }
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String
}

extension ItemModel{
    static func ==(lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}


struct DetailModel: Codable, Hashable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String
    let description: String
    let email: String
    let phoneNumber: String
    let address: String
}

