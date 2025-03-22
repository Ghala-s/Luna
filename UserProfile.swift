//
//  UserProfile.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//
import Foundation

struct UserProfile: Codable, Identifiable {
    var id = UUID()
    var name: String
    var age: Int
    var birthday: Date?
    
    init(name: String = "", age: Int = 25, birthday: Date? = nil) {
        self.name = name
        self.age = age
        self.birthday = birthday
    }
}
