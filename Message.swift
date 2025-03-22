//
//  Message.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//
import Foundation

struct Message: Identifiable {
    let id = UUID()
    let sender: String
    let content: String
}
