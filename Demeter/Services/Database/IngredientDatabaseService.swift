import Foundation
import SwiftData

/// IngredientDatabaseService handles ingredient database queries and fuzzy matching
class IngredientDatabaseService {
    static let shared = IngredientDatabaseService()
    
    private let modelContext: ModelContext?
    
    enum DatabaseError: LocalizedError {
        case modelContextUnavailable
        case queryFailed
        case noResults
        
        var errorDescription: String? {
            switch self {
            case .modelContextUnavailable:
                return "Model context not available"
            case .queryFailed:
                return "Database query failed"
            case .noResults:
                return "No ingredients found"
            }
        }
    }
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    /// Search for ingredients by name with fuzzy matching
    func searchIngredients(query: String, limit: Int = 20) throws -> [Ingredient] {
        guard let modelContext = modelContext else {
            throw DatabaseError.modelContextUnavailable
        }
        
        let searchQuery = query.lowercased()
        
        // Fetch all ingredients
        var descriptor = FetchDescriptor<Ingredient>()
        descriptor.fetchLimit = 1000
        
        let allIngredients = try modelContext.fetch(descriptor)
        
        // Score and filter ingredients
        let scoredIngredients = allIngredients.compactMap { ingredient -> (Ingredient, Double)? in
            let score = calculateRelevanceScore(
                ingredient: ingredient,
                query: searchQuery
            )
            return score > 0 ? (ingredient, score) : nil
        }
        
        // Sort by score and return top results
        let sorted = scoredIngredients.sorted { $0.1 > $1.1 }
        return Array(sorted.prefix(limit)).map { $0.0 }
    }
    
    /// Get ingredient by ID
    func getIngredient(id: String) throws -> Ingredient? {
        guard let modelContext = modelContext else {
            throw DatabaseError.modelContextUnavailable
        }
        
        var descriptor = FetchDescriptor<Ingredient>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        
        return try modelContext.fetch(descriptor).first
    }
    
    /// Get all ingredients in a category
    func getIngredientsByCategory(category: String) throws -> [Ingredient] {
        guard let modelContext = modelContext else {
            throw DatabaseError.modelContextUnavailable
        }
        
        // Fetch all and filter by category string
        var descriptor = FetchDescriptor<Ingredient>()
        descriptor.fetchLimit = 100
        
        let allIngredients = try modelContext.fetch(descriptor)
        return allIngredients.filter { $0.category.rawValue == category }
    }
    
    /// Get popular ingredients (by usage count)
    func getPopularIngredients(limit: Int = 20) throws -> [Ingredient] {
        guard let modelContext = modelContext else {
            throw DatabaseError.modelContextUnavailable
        }
        
        var descriptor = FetchDescriptor<Ingredient>(
            sortBy: [SortDescriptor(\.usageCount, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        
        return try modelContext.fetch(descriptor)
    }
    
    /// Calculate relevance score for an ingredient
    private func calculateRelevanceScore(ingredient: Ingredient, query: String) -> Double {
        var score = 0.0
        
        let ingredientName = ingredient.name.lowercased()
        
        // Exact name match (highest priority)
        if ingredientName == query {
            score += 100.0
        }
        // Name contains query
        else if ingredientName.contains(query) {
            score += 50.0
        }
        
        // Alias matches
        for alias in ingredient.aliases {
            let aliasLower = alias.lowercased()
            if aliasLower == query {
                score += 80.0
            } else if aliasLower.contains(query) {
                score += 40.0
            }
        }
        
        // Fuzzy matching (Levenshtein distance)
        let distance = levenshteinDistance(query, ingredientName)
        let maxLength = max(query.count, ingredientName.count)
        if maxLength > 0 {
            let similarity = 1.0 - Double(distance) / Double(maxLength)
            if similarity > 0.7 {
                score += similarity * 30.0
            }
        }
        
        // Usage frequency (popularity)
        score += Double(ingredient.usageCount) * 0.5
        
        return score
    }
    
    /// Calculate Levenshtein distance for fuzzy matching
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let s1 = Array(s1)
        let s2 = Array(s2)
        
        let m = s1.count
        let n = s2.count
        
        var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        
        for i in 0...m {
            dp[i][0] = i
        }
        
        for j in 0...n {
            dp[0][j] = j
        }
        
        for i in 1...m {
            for j in 1...n {
                if s1[i - 1] == s2[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1]
                } else {
                    dp[i][j] = 1 + min(
                        dp[i - 1][j],      // deletion
                        dp[i][j - 1],      // insertion
                        dp[i - 1][j - 1]   // substitution
                    )
                }
            }
        }
        
        return dp[m][n]
    }
    
    /// Increment usage count for an ingredient
    func incrementUsageCount(ingredientId: String) throws {
        guard let modelContext = modelContext else {
            throw DatabaseError.modelContextUnavailable
        }
        
        if let ingredient = try getIngredient(id: ingredientId) {
            ingredient.usageCount += 1
            try modelContext.save()
        }
    }
}