//
//  UserProfile.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-21.
//
import Foundation

struct UserProfile: Codable, Identifiable {
    var id = UUID()
    var username: String
    var password: String 
    var name: String
    var age: Int
    var birthday: Date?
    
    init(username: String = "", password: String = "",name: String = "", age: Int = 25, birthday: Date? = nil) {
        self.username = username
        self.password = password
        self.name = name
        self.age = age
        self.birthday = birthday
    }
}
