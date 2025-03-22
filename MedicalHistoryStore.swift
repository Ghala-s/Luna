//
//  MedicalHistoryStore.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//
import Foundation
import Combine

// Make MedicalHistoryStore conform to ObservableObject
class MedicalHistoryStore: ObservableObject {
    static let shared = MedicalHistoryStore()
    
    // The @Published property wrapper makes sure views observing this variable are updated when it changes
    @Published var histories: [CycleHistory] = []
    
    // Function to add new cycle history
    func addCycleHistory(_ history: CycleHistory) {
        histories.append(history)
    }
    
    // Function to get the most recent cycle history
    func getLatestHistory() -> CycleHistory? {
        return histories.last
    }
}

// Struct to define a single cycle history
struct CycleHistory {
    var periodStartDate: Date
    var cycleLength: Int
    var symptoms: [String]
    var symptomSeverity: Int
    var symptomDuration: String
}
