import Foundation
import Network

/// NetworkService provides a base networking layer for all HTTP/HTTPS requests
/// with automatic retry logic, connectivity monitoring, and offline support.
class NetworkService {
    static let shared = NetworkService()
    
    private let session: URLSession
    private let monitor = NetworkMonitor.shared
    private var offlineQueue: [PendingRequest] = []
    private let queue = DispatchQueue(label: "com.demeter.network", attributes: .concurrent)
    
    enum NetworkError: LocalizedError {
        case invalidURL
        case invalidRequest
        case noData
        case decodingError
        case httpError(statusCode: Int, message: String)
        case networkUnavailable
        case timeout
        case unknown(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .invalidRequest:
                return "Invalid request"
            case .noData:
                return "No data received"
            case .decodingError:
                return "Failed to decode response"
            case .httpError(let code, let message):
                return "HTTP Error \(code): \(message)"
            case .networkUnavailable:
                return "Network is unavailable"
            case .timeout:
                return "Request timeout"
            case .unknown(let error):
                return error.localizedDescription
            }
        }
    }
    
    private struct PendingRequest {
        let url: URL
        let method: String
        let headers: [String: String]
        let body: Data?
        let timestamp: Date
    }
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        config.httpShouldUsePipelining = true
        config.httpMaximumConnectionsPerHost = 4
        
        self.session = URLSession(configuration: config)
        
        // Monitor network changes
        monitor.onStatusChange = { [weak self] isConnected in
            if isConnected {
                self?.processOfflineQueue()
            }
        }
    }
    
    /// Perform a GET request
    func get<T: Decodable>(
        url: URL,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        try await performRequest(
            url: url,
            method: "GET",
            headers: headers,
            body: nil,
            responseType: responseType
        )
    }
    
    /// Perform a POST request
    func post<T: Decodable>(
        url: URL,
        headers: [String: String] = [:],
        body: Data?,
        responseType: T.Type
    ) async throws -> T {
        try await performRequest(
            url: url,
            method: "POST",
            headers: headers,
            body: body,
            responseType: responseType
        )
    }
    
    /// Perform a generic request with retry logic
    private func performRequest<T: Decodable>(
        url: URL,
        method: String,
        headers: [String: String],
        body: Data?,
        responseType: T.Type,
        attempt: Int = 1
    ) async throws -> T {
        // Check network connectivity
        guard monitor.isConnected else {
            // Queue request for later
            queue.async(flags: .barrier) {
                self.offlineQueue.append(
                    PendingRequest(
                        url: url,
                        method: method,
                        headers: headers,
                        body: body,
                        timestamp: Date()
                    )
                )
            }
            throw NetworkError.networkUnavailable
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 30
        
        // Set headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set body if present
        if let body = body {
            request.httpBody = body
            request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // Handle HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidRequest
            }
            
            // Handle status codes
            switch httpResponse.statusCode {
            case 200...299:
                // Success
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
                
            case 401:
                throw NetworkError.httpError(statusCode: 401, message: "Unauthorized")
                
            case 429:
                // Rate limited - retry with backoff
                if attempt < 3 {
                    let delay = UInt64(pow(2.0, Double(attempt - 1)) * 1_000_000_000)
                    try await Task.sleep(nanoseconds: delay)
                    return try await performRequest(
                        url: url,
                        method: method,
                        headers: headers,
                        body: body,
                        responseType: responseType,
                        attempt: attempt + 1
                    )
                }
                throw NetworkError.httpError(statusCode: 429, message: "Rate limited")
                
            case 500...599:
                // Server error - retry
                if attempt < 3 {
                    let delay = UInt64(pow(2.0, Double(attempt - 1)) * 1_000_000_000)
                    try await Task.sleep(nanoseconds: delay)
                    return try await performRequest(
                        url: url,
                        method: method,
                        headers: headers,
                        body: body,
                        responseType: responseType,
                        attempt: attempt + 1
                    )
                }
                throw NetworkError.httpError(statusCode: httpResponse.statusCode, message: "Server error")
                
            default:
                throw NetworkError.httpError(statusCode: httpResponse.statusCode, message: "HTTP error")
            }
        } catch let error as NetworkError {
            throw error
        } catch let error as URLError {
            if error.code == .timedOut {
                throw NetworkError.timeout
            }
            throw NetworkError.unknown(error)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    /// Process queued requests when network becomes available
    private func processOfflineQueue() {
        queue.async(flags: .barrier) {
            let requests = self.offlineQueue
            self.offlineQueue.removeAll()
            
            Task {
                for request in requests {
                    // Retry queued requests
                    do {
                        var urlRequest = URLRequest(url: request.url)
                        urlRequest.httpMethod = request.method
                        
                        for (key, value) in request.headers {
                            urlRequest.setValue(value, forHTTPHeaderField: key)
                        }
                        
                        if let body = request.body {
                            urlRequest.httpBody = body
                        }
                        
                        _ = try await self.session.data(for: urlRequest)
                    } catch {
                        // Re-queue if still fails
                        self.queue.async(flags: .barrier) {
                            self.offlineQueue.append(request)
                        }
                    }
                }
            }
        }
    }
    
    /// Get current network connectivity status
    var isConnected: Bool {
        monitor.isConnected
    }
}