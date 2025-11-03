//
//  FoodEntry.swift
//  Demeter
//
//  Created by Kilo Code
//  Generated from specs/001-swiftdata-models/data-model.md
//

import SwiftData
import Foundation

@Model
final class FoodEntry {
    // Identity
    @Attribute(.unique) var id: UUID

    // Temporal
    var timestamp: Date

    // Raw Input
    var rawDescription: String

    // Parsed Data
    var foodName: String
    var quantity: Double
    var unit: String

    // Nutritional Data
    var calories: Double
    var protein: Double
    var carbohydrates: Double
    var fat: Double

    // LLM Metadata
    var confidence: Double
    var matchedIngredientID: String?

    // Relationships
    @Relationship(deleteRule: .nullify, inverse: \DailyTotal.entries)
    var dailyTotal: DailyTotal?

    // Initialization
    init(
        timestamp: Date,
        rawDescription: String,
        foodName: String,
        quantity: Double,
        unit: String,
        calories: Double,
        protein: Double,
        carbohydrates: Double,
        fat: Double,
        confidence: Double,
        matchedIngredientID: String? = nil
    ) {
        self.id = UUID()
        self.timestamp = timestamp
        self.rawDescription = rawDescription
        self.foodName = foodName
        self.quantity = quantity
        self.unit = unit
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.confidence = confidence
        self.matchedIngredientID = matchedIngredientID
    }

    // Validation
    var isValid: Bool {
        quantity > 0 &&
        !foodName.isEmpty &&
        calories >= 0 &&
        protein >= 0 &&
        carbohydrates >= 0 &&
        fat >= 0
    }

    // Computed Properties
    var nutritionalSummary: String {
        String(format: "%.0f cal, %.1fg protein, %.1fg carbs, %.1fg fat",
               calories, protein, carbohydrates, fat)
    }
}