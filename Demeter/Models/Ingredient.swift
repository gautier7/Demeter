//
//  Ingredient.swift
//  Demeter
//
//  Created by Kilo Code
//  Generated from specs/001-swiftdata-models/data-model.md
//

import SwiftData
import Foundation

@Model
final class Ingredient {
    // Identity
    @Attribute(.unique) var id: String

    // Basic Info
    var name: String
    var aliases: [String]

    // Nutritional Data (per 100g)
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbsPer100g: Double
    var fatPer100g: Double
    var fiberPer100g: Double?
    var sugarPer100g: Double?

    // Serving Information
    var commonServingSize: Double
    var commonServingUnit: String
    var servingSizeVariations: [ServingVariation]

    // Metadata
    var category: IngredientCategory
    var subcategory: String?
    var tags: [String]
    var source: DataSource
    var verificationStatus: VerificationStatus
    var lastUpdated: Date
    var usageCount: Int

    // Search Optimization
    var searchTokens: [String]

    // Initialization
    init(
        id: String,
        name: String,
        caloriesPer100g: Double,
        proteinPer100g: Double,
        carbsPer100g: Double,
        fatPer100g: Double,
        commonServingSize: Double,
        commonServingUnit: String,
        category: IngredientCategory,
        source: DataSource
    ) {
        self.id = id
        self.name = name
        self.aliases = []
        self.caloriesPer100g = caloriesPer100g
        self.proteinPer100g = proteinPer100g
        self.carbsPer100g = carbsPer100g
        self.fatPer100g = fatPer100g
        self.commonServingSize = commonServingSize
        self.commonServingUnit = commonServingUnit
        self.servingSizeVariations = []
        self.category = category
        self.tags = []
        self.source = source
        self.verificationStatus = .pending
        self.lastUpdated = Date()
        self.usageCount = 0
        self.searchTokens = []
    }

    // Computed Properties
    var isVerified: Bool {
        verificationStatus == .verified
    }

    var displayName: String {
        name.capitalized
    }

    var nutritionalInfoPer100g: NutritionalInfo {
        NutritionalInfo(
            calories: caloriesPer100g,
            protein: proteinPer100g,
            carbs: carbsPer100g,
            fat: fatPer100g,
            fiber: fiberPer100g,
            sugar: sugarPer100g
        )
    }

    // Methods
    func incrementUsage() {
        usageCount += 1
    }

    func addAlias(_ alias: String) {
        if !aliases.contains(alias.lowercased()) {
            aliases.append(alias.lowercased())
        }
    }

    func matches(searchTerm: String) -> Bool {
        let term = searchTerm.lowercased()
        return name.localizedCaseInsensitiveContains(term) ||
               aliases.contains { $0.localizedCaseInsensitiveContains(term) }
    }
}

// Supporting Types
struct ServingVariation: Codable {
    var amount: Double
    var unit: String
    var description: String
    var gramsEquivalent: Double
}

struct NutritionalInfo {
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    let fiber: Double?
    let sugar: Double?
}

enum IngredientCategory: String, Codable, CaseIterable {
    case protein, vegetable, fruit, grain, dairy, fat, beverage, snack, condiment
}

enum DataSource: String, Codable, CaseIterable {
    case usda, nutritionix, custom, userContributed
}

enum VerificationStatus: String, Codable, CaseIterable {
    case verified, pending, unverified
}