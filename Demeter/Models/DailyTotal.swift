//
//  DailyTotal.swift
//  Demeter
//
//  Created by Kilo Code
//  Generated from specs/001-swiftdata-models/data-model.md
//

import SwiftData
import Foundation

@Model
final class DailyTotal {
    // Identity
    @Attribute(.unique) var id: UUID

    // Date (normalized to midnight)
    var date: Date

    // Aggregated Nutrition
    var totalCalories: Double
    var totalProtein: Double
    var totalCarbohydrates: Double
    var totalFat: Double

    // Metadata
    var entryCount: Int

    // Relationships
    @Relationship(deleteRule: .cascade)
    var entries: [FoodEntry]

    // Initialization
    init(date: Date) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.totalCalories = 0
        self.totalProtein = 0
        self.totalCarbohydrates = 0
        self.totalFat = 0
        self.entryCount = 0
        self.entries = []
    }

    // Computed Properties
    var averageConfidence: Double {
        guard !entries.isEmpty else { return 0 }
        return entries.reduce(0) { $0 + $1.confidence } / Double(entries.count)
    }

    var hasEntries: Bool {
        !entries.isEmpty
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Methods
    func addEntry(_ entry: FoodEntry) {
        entries.append(entry)
        entry.dailyTotal = self
        updateTotals()
    }

    func removeEntry(_ entry: FoodEntry) {
        entries.removeAll { $0.id == entry.id }
        entry.dailyTotal = nil
        updateTotals()
    }

    func containsEntry(withId id: UUID) -> Bool {
        entries.contains { $0.id == id }
    }

    func getEntry(withId id: UUID) -> FoodEntry? {
        entries.first { $0.id == id }
    }

    private func updateTotals() {
        totalCalories = entries.reduce(0) { $0 + $1.calories }
        totalProtein = entries.reduce(0) { $0 + $1.protein }
        totalCarbohydrates = entries.reduce(0) { $0 + $1.carbohydrates }
        totalFat = entries.reduce(0) { $0 + $1.fat }
        entryCount = entries.count
    }
}