import Foundation

/// OpenAI Chat Completion Request DTO
struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
    let maxTokens: Int?
    let responseFormat: ResponseFormat?
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case temperature
        case maxTokens = "max_tokens"
        case responseFormat = "response_format"
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
    
    struct ResponseFormat: Codable {
        let type: String
    }
}

/// OpenAI Chat Completion Response DTO
struct OpenAIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage?
    
    struct Choice: Codable {
        let index: Int
        let message: Message
        let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case index
            case message
            case finishReason = "finish_reason"
        }
        
        struct Message: Codable {
            let role: String
            let content: String
        }
    }
    
    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

/// Parsed nutrition data from LLM response
struct NutritionData: Codable {
    let foodItems: [FoodItem]
    let totalNutrition: TotalNutrition
    
    enum CodingKeys: String, CodingKey {
        case foodItems = "food_items"
        case totalNutrition = "total_nutrition"
    }
    
    struct FoodItem: Codable {
        let name: String
        let quantity: Double
        let unit: String
        let calories: Double
        let protein: Double
        let carbohydrates: Double
        let fat: Double
        let confidence: Double
        let matchedIngredientId: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case quantity
            case unit
            case calories
            case protein
            case carbohydrates
            case fat
            case confidence
            case matchedIngredientId = "matched_ingredient_id"
        }
    }
    
    struct TotalNutrition: Codable {
        let calories: Double
        let protein: Double
        let carbohydrates: Double
        let fat: Double
    }
}