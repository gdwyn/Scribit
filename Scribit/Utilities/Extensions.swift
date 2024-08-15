//
//  Extensions.swift
//  Scribit
//
//  Created by Godwin IE on 15/08/2024.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidUUID() -> Bool {
        let uuidFormat = "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
        let uuidPredicate = NSPredicate(format: "SELF MATCHES %@", uuidFormat)
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return uuidPredicate.evaluate(with: trimmedString)
    }
}
