import Foundation

/// LLMService handles OpenAI GPT-4o integration for nutritional analysis
class LLMService {
    static let shared = LLMService()
    
    private let networkService = NetworkService.shared
    private let securityService = SecurityService.shared
    private let apiEndpoint = "https://api.openai.com/v1/chat/completions"
    private let model = "gpt-4o-turbo"
    private let temperature = 0.3
    private let maxTokens = 500
    
    private var responseCache: [String: CachedResponse] = [:]
    private let cacheQueue = DispatchQueue(label: "com.demeter.llm.cache", attributes: .concurrent)
    
    enum LLMError: LocalizedError {
        case noAPIKey
        case invalidResponse
        case parsingError
        case apiError(String)
        
        var errorDescription: String? {
            switch self {
            case .noAPIKey:
                return "OpenAI API key not configured"
            case .invalidResponse:
                return "Invalid response from OpenAI API"
            case .parsingError:
                return "Failed to parse nutritional data"
            case .apiError(let message):
                return "API Error: \(message)"
            }
        }
    }
    
    private struct CachedResponse {
        let data: NutritionData
        let timestamp: Date
        let ttl: TimeInterval = 86400 // 24 hours
        
        var isExpired: Bool {
            Date().timeIntervalSince(timestamp) > ttl
        }
    }
    
    /// Analyze food description and return nutritional data
    func analyzeFood(
        description: String,
        ingredientContext: [String] = []
    ) async throws -> NutritionData {
        // Check cache first
        let cacheKey = description.lowercased()
        if let cached = getCachedResponse(key: cacheKey), !cached.isExpired {
            return cached.data
        }
        
        // Get API key from Keychain
        let apiKey: String
        do {
            apiKey = try securityService.retrieveAPIKey(account: "openai_api_key")
        } catch {
            throw LLMError.noAPIKey
        }
        
        // Build system prompt
        let systemPrompt = buildSystemPrompt(ingredientContext: ingredientContext)
        
        // Create request
        let request = OpenAIRequest(
            model: model,
            messages: [
                OpenAIRequest.Message(role: "system", content: systemPrompt),
                OpenAIRequest.Message(role: "user", content: description)
            ],
            temperature: temperature,
            maxTokens: maxTokens,
            responseFormat: OpenAIRequest.ResponseFormat(type: "json_object")
        )
        
        // Encode request
        let encoder = JSONEncoder()
        let requestData = try encoder.encode(request)
        
        // Create URL request
        guard let url = URL(string: apiEndpoint) else {
            throw LLMError.invalidResponse
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = requestData
        
        // Make request
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Parse response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw LLMError.apiError("HTTP error")
        }
        
        let decoder = JSONDecoder()
        let openAIResponse = try decoder.decode(OpenAIResponse.self, from: data)
        
        guard let choice = openAIResponse.choices.first,
              let content = choice.message.content.data(using: .utf8) else {
            throw LLMError.invalidResponse
        }
        
        // Parse nutrition data
        let nutritionData = try decoder.decode(NutritionData.self, from: content)
        
        // Cache response
        setCachedResponse(key: cacheKey, data: nutritionData)
        
        return nutritionData
    }
    
    /// Build system prompt with ingredient context
    private func buildSystemPrompt(ingredientContext: [String]) -> String {
        let ingredientList = ingredientContext.joined(separator: ", ")
        
        return """
        You are a nutritional analysis assistant for the Demeter calorie tracking app.
        Your task is to parse natural language food descriptions and return structured nutritional data in JSON format.
        
        CUSTOM INGREDIENT DATABASE:
        \(ingredientList.isEmpty ? "No specific ingredients provided" : ingredientList)
        
        USER INPUT RULES:
        1. Match user descriptions to custom ingredients when possible
        2. Use "matched_ingredient_id" field when match found
        3. Estimate quantities if not specified (use common serving sizes)
        4. Provide confidence score (0.0-1.0) for each food item
        5. If no custom ingredient matches, use general nutritional knowledge
        6. Always return valid JSON in the specified format
        
        RESPONSE FORMAT:
        {
          "food_items": [
            {
              "name": "string",
              "quantity": number,
              "unit": "string",
              "calories": number,
              "protein": number,
              "carbohydrates": number,
              "fat": number,
              "confidence": number,
              "matched_ingredient_id": "string or null"
            }
          ],
          "total_nutrition": {
            "calories": number,
            "protein": number,
            "carbohydrates": number,
            "fat": number
          }
        }
        """
    }
    
    /// Get cached response
    private func getCachedResponse(key: String) -> CachedResponse? {
        var result: CachedResponse?
        cacheQueue.sync {
            result = responseCache[key]
        }
        return result
    }
    
    /// Set cached response
    private func setCachedResponse(key: String, data: NutritionData) {
        cacheQueue.async(flags: .barrier) {
            self.responseCache[key] = CachedResponse(data: data, timestamp: Date())
            
            // Limit cache size to 100 entries
            if self.responseCache.count > 100 {
                let oldestKey = self.responseCache.min { $0.value.timestamp < $1.value.timestamp }?.key
                if let key = oldestKey {
                    self.responseCache.removeValue(forKey: key)
                }
            }
        }
    }
}