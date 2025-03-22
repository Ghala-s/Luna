import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    private let apiKey = loadAPIKey()
    private var isFirstMessage = true // Track if it's the first message in the conversation
    
    func sendMessage(prompt: String, historyStore: MedicalHistoryStore, userProfile: UserProfile, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion("Error: Invalid URL")
            return
        }

        let latestHistory = historyStore.histories.last

        // Build a summary of symptoms from the medical history
        let symptomSummary: String
        if let latestHistory = latestHistory, !latestHistory.symptoms.isEmpty {
            symptomSummary = "Current symptoms: \(latestHistory.symptoms.joined(separator: ", ")).\nSymptom severity: \(latestHistory.symptomSeverity).\nDuration: \(latestHistory.symptomDuration)."
        } else {
            symptomSummary = "No recent symptoms recorded."
        }

        // Age-specific guidance (used internally, not shown to the user)
        let ageGuidance: String
        if userProfile.age < 20 {
            ageGuidance = "The user is under 20. Focus on cycle regularity, common early symptoms, and reassurance."
        } else if userProfile.age >= 20 && userProfile.age <= 45 {
            ageGuidance = "The user is between 20-45. Provide balanced advice for maintaining cycle health."
        } else {
            ageGuidance = "The user is over 45. Be mindful of perimenopause and menopause symptoms, and gently suggest consulting a doctor if appropriate."
        }

        // First message acknowledgment (empathetic and subtle)
        let firstMessageAcknowledgment = isFirstMessage ? "Hi there! 🌸 I'm here to support you through any changes or challenges you're experiencing. " : ""

        let systemPrompt = """
        You are Luna, a friendly and supportive menstrual cycle companion. Your role is to provide helpful, empathetic, and non-judgmental advice. Follow these rules strictly:

        1. Always respond in a warm, friendly, and conversational tone, like a caring friend.
        2. Focus primarily on home remedies, lifestyle tips, and natural solutions that can be done at home.
        3. If a symptom or situation sounds concerning or severe, provide a detailed recommendation to consult a doctor or healthcare professional.
        4. For mild or moderate symptoms, include a small, gentle reminder to consult a doctor if symptoms persist or worsen.
        5. Never provide medical diagnoses or prescription advice.
        6. Keep responses concise and easy to understand.
        7. Use emojis occasionally to make the conversation more friendly and approachable.
        8. Always consider the user's age when responding, but do not mention it directly unless absolutely necessary.
           - For users under 20: Focus on cycle regularity, common early symptoms, and reassurance.
           - For users between 20-45: Provide balanced advice for maintaining cycle health.
           - For users over 45: Be mindful of perimenopause and menopause symptoms, and gently suggest consulting a doctor if appropriate.
        9. For the first message in a conversation, acknowledge the user warmly and offer support without being overly direct.

        User Profile:
        Name: \(userProfile.name)
        Age: \(userProfile.age)
        Birthday: \(userProfile.birthday?.description ?? "Not provided")
        
        Latest cycle details:
        Start Date: \(latestHistory?.periodStartDate.description ?? "N/A")
        Cycle Length: \(latestHistory?.cycleLength ?? 0) days
        \(symptomSummary)

        \(ageGuidance)
        """

        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": prompt]
        ]

        let json: [String: Any] = [
            "model": "gpt-4",
            "messages": messages,
            "max_tokens": 300,
            "temperature": 0.7
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            completion("Error: Failed to encode request.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion("Oops! Something went wrong. Please try again later. 🫠")
                return
            }
            guard let data = data else {
                completion("Hmm, I didn't get a response. Let's try that again!")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    let finalResponse = self.isFirstMessage ? "\(firstMessageAcknowledgment)\(content)" : content
                    self.isFirstMessage = false // Mark first message as completed
                    completion(finalResponse.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    completion("Hmm, I'm having trouble understanding that. Could you rephrase? 🤔")
                }
            } catch {
                completion("Oops! Something went wrong on my end. Let's try again! 🌸")
            }
        }
        
        task.resume()
    }

    // New function to handle symptom-specific queries
    func handleSymptomQuery(historyStore: MedicalHistoryStore, userProfile: UserProfile, completion: @escaping (String) -> Void) {
        guard let latestHistory = historyStore.histories.last else {
            completion("It looks like you haven't recorded any symptoms yet. Would you like to add some in the Medical History section? 🌸")
            return
        }

        let prompt = """
        Based on my latest symptoms: \(latestHistory.symptoms.joined(separator: ", ")), severity: \(latestHistory.symptomSeverity), and duration: \(latestHistory.symptomDuration), what can I do to feel better?
        """

        sendMessage(prompt: prompt, historyStore: historyStore, userProfile: userProfile, completion: completion)
    }
}
