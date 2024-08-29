//
//  Presence.swift
//  Scribit
//
//  Created by Godwin IE on 29/08/2024.
//

import Foundation

struct Presence: Codable, Identifiable, Equatable {
    let id: UUID
    let email: String
}
