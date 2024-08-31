//
//  LoadingStates.swift
//  Scribit
//
//  Created by Godwin IE on 15/08/2024.
//

import Foundation

enum LoadingState: Equatable {
    case none
    case loading
    case success
    case error(String)
}
