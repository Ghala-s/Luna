//
//  MedicalHistory.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-20.
//

import Foundation

struct MedicalHistory: Identifiable, Codable {
    let id: UUID
    var periodStartDate: Date
    var cycleLength: Int
    var symptoms: [String]
    var age: Int
    var symptomSeverity: Int
    var symptomDuration: String
    
    init(periodStartDate: Date, cycleLength: Int, symptoms: [String], age: Int, symptomSeverity: Int, symptomDuration: String) {
        self.id = UUID()
        self.periodStartDate = periodStartDate
        self.cycleLength = cycleLength
        self.symptoms = symptoms
        self.age = age
        self.symptomSeverity = symptomSeverity
        self.symptomDuration = symptomDuration
    }
}


class MedicalHistoryStore: ObservableObject {
    @Published var histories: [MedicalHistory] = [] {
        didSet {
            saveHistories()
        }
    }
    
    init() {
        loadHistories()
    }
    
    private func getFileURL() -> URL {
      
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("medical_history.json")
    }
    
    private func saveHistories() {
       
        do {
            let data = try JSONEncoder().encode(histories)
            try data.write(to: getFileURL())
        } catch {
            print("Error saving medical histories: \(error)")
        }
    }
    
    private func loadHistories() {
       
        let fileURL = getFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            histories = try JSONDecoder().decode([MedicalHistory].self, from: data)
        } catch {
            print("No saved histories found or error loading: \(error)")
        }
    }
}

