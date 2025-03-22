//
//  MedicalHistoryView.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-20.
//

import SwiftUI

struct SymptomEntry: Identifiable, Codable {
    let id = UUID()
    var name: String
    var severity: Int
    var duration: String
}

struct MedicalHistoryView: View {
    @StateObject private var historyStore = MedicalHistoryStore()
    @State private var periodStartDate = Date()
    @State private var cycleLength = 28
    @State private var symptoms: [SymptomEntry] = []
    @State private var newSymptom = ""
    @State private var newSeverity = 0
    @State private var newDuration = "First few days"
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add New Cycle")) {
                        DatePicker("Period Start Date", selection: $periodStartDate, displayedComponents: .date)
                        Stepper("Cycle Length: \(cycleLength) days", value: $cycleLength, in: 21...35)

                        Section(header: Text("Symptoms")) {
                            ForEach(symptoms) { symptom in
                                HStack {
                                    Text(symptom.name)
                                    Spacer()
                                    Text("Severity: \(symptom.severity)/10")
                                    Text("\(symptom.duration)")
                                }
                            }
                            .onDelete { indexSet in
                                symptoms.remove(atOffsets: indexSet)
                            }

                            HStack {
                                TextField("Symptom Name", text: $newSymptom)
                                Picker("", selection: $newSeverity) {
                                    ForEach(0..<11) { Text("\($0)").tag($0) }
                                }
                                Picker("", selection: $newDuration) {
                                    Text("First few days").tag("First few days")
                                    Text("Throughout cycle").tag("Throughout cycle")
                                }
                                Button("+") {
                                    if !newSymptom.isEmpty {
                                        symptoms.append(SymptomEntry(name: newSymptom, severity: newSeverity, duration: newDuration))
                                        newSymptom = ""
                                    }
                                }
                            }
                        }
                    }

                    Button("Save Cycle") { saveCycle() }
                        .disabled(symptoms.isEmpty)
                }
                .navigationTitle("Medical History")
            }
        }
    }

    func saveCycle() {
        historyStore.histories.append(MedicalHistory(periodStartDate: periodStartDate, cycleLength: cycleLength, symptoms: symptoms.map { $0.name }, age: 0, symptomSeverity: 0, symptomDuration: ""))
    }
}

#Preview { MedicalHistoryView() }
