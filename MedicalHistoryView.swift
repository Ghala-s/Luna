//
//  MedicalHistoryView.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//
import SwiftUI

struct SymptomEntry: Identifiable, Codable {
    var id = UUID()
    var name: String
    var severity: Int
    var duration: String
}

struct CycleEntry: Identifiable, Codable {
    var id = UUID()
    var startDate: Date
    var cycleLength: Int
    var symptoms: [SymptomEntry]
}

struct MedicalHistoryView: View {
    @State private var startDate = Date()
    @State private var cycleLength = 27
    @State private var newSymptom = ""
    @State private var newSeverity = 0
    @State private var newDuration = "First few days"
    @State private var symptoms: [SymptomEntry] = []
    @State private var cycles: [CycleEntry] = []

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("ADD NEW CYCLE")
                    .font(.headline)
                    .padding(.bottom, 5)

                Form {
                    DatePicker("Period Start Date", selection: $startDate, displayedComponents: .date)

                    Stepper(value: $cycleLength, in: 20...40) {
                        Text("Cycle Length: \(cycleLength) days")
                    }

                    Section(header: Text("Add Symptom")) {
                        TextField("Symptom Name", text: $newSymptom)

                        Stepper("Severity: \(newSeverity)", value: $newSeverity, in: 0...10)

                        Picker("Duration", selection: $newDuration) {
                            Text("First few days").tag("First few days")
                            Text("Throughout cycle").tag("Throughout cycle")
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Button(action: {
                            if !newSymptom.isEmpty {
                                symptoms.append(SymptomEntry(name: newSymptom, severity: newSeverity, duration: newDuration))
                                newSymptom = ""
                                newSeverity = 0
                                newDuration = "First few days"
                            }
                        }) {
                            Text("Add Symptom")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }

                    if !symptoms.isEmpty {
                        Section(header: Text("Symptoms Added")) {
                            ForEach(symptoms) { symptom in
                                VStack(alignment: .leading) {
                                    Text(symptom.name)
                                        .bold()
                                    Text("Severity: \(symptom.severity)")
                                    Text("Duration: \(symptom.duration)")
                                }
                            }
                        }
                    }

                    Button(action: saveCycle) {
                        Text("Save Cycle")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(symptoms.isEmpty ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(symptoms.isEmpty)
                }
            }
            .navigationTitle("Medical History")
            .padding()
        }
    }

    func saveCycle() {
        let newCycle = CycleEntry(startDate: startDate, cycleLength: cycleLength, symptoms: symptoms)
        cycles.append(newCycle)
        symptoms.removeAll()
        startDate = Date()
        cycleLength = 27
    }
}

struct MedicalHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalHistoryView()
    }
}
