//
//  OpenAIService.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-20.
//

import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    private let apiKey = loadAPIKey()
    
    func sendMessage(prompt: String, historyStore: MedicalHistoryStore, userProfileStore: UserProfileStore, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion("Error: Invalid URL")
            return
        }
        
        let latestHistory = historyStore.histories.last
        
        let userAge = userProfileStore.userProfile.age ?? 25
        let cyclePhase = determineCyclePhase(for: userAge)
        
        let systemPrompt = """
        You are a supportive menstrual cycle companion named Luna.
        The user is currently in the \(cyclePhase) phase.
        Latest cycle details:
        Start Date: \(latestHistory?.periodStartDate.description ?? "N/A")
        Cycle Length: \(latestHistory?.cycleLength ?? 0) days
        Symptoms: \((latestHistory?.symptoms.joined(separator: ", ")) ?? "None")
        Symptom Severity: \(latestHistory?.symptomSeverity ?? 0)
        Duration: \(latestHistory?.symptomDuration ?? "N/A")
        User Age: \(userAge)
        Provide supportive, informative, and friendly responses based on this data.
        """
        
        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": prompt]
        ]
        
        let json: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "max_tokens": 100
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                completion("Error: No data received.")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    completion("Error: Could not parse response.")
                }
            } catch {
                completion("Error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    private func determineCyclePhase(for age: Int) -> String {
        if age < 13 {
            return "pre-puberty"
        } else if age <= 50 {
            return "menstrual cycle"
        } else {
            return "menopause"
        }
    }
}
