//
//  Secrets.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-20.
//

import Foundation

func loadAPIKey() -> String {
    guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: filePath),
          let apiKey = plist["OPENAI_API_KEY"] as? String else {
        fatalError("API Key not found. Make sure you have Secrets.plist in your project!")
    }
    return apiKey
}
