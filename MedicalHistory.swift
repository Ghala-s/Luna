//
//  MedicalHistory.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
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
