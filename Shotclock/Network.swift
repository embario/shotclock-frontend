//
//  Network.swift
//  Shotclock
//
//  Created by Mario Barrenechea on 9/8/22.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidRequestBody
    case invalidResponse
    case noData
    case decodingError(Error)
    case serverError(statusCode: Int, data: Data?)
}


class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = AppConfig.shared.string("BASE_URL")
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func sendRequest<T: Decodable, U: Encodable>(
        endpoint: String,
        method: String = "GET",
        body: U? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // ✅ Construct URL safely
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        // ✅ Prepare request
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ Attach encoded body
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return completion(.failure(NetworkError.invalidRequestBody))
            }
        }
        
        // ✅ Start the network task
        session.dataTask(with: request) { data, response, error in
            // ✅ Handle network errors first
            if let error = error {
                return self.completeOnMainThread(.failure(error), completion)
            }
            
            // ✅ Validate the response status code
            guard let httpResponse = response as? HTTPURLResponse else {
                return self.completeOnMainThread(.failure(NetworkError.invalidResponse), completion)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return self.completeOnMainThread(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)), completion)
            }
            
            // ✅ Validate the presence of data
            guard let data = data else {
                return self.completeOnMainThread(.failure(NetworkError.noData), completion)
            }
            
            // ✅ Decode response
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                self.completeOnMainThread(.success(decodedResponse), completion)
            } catch {
                self.completeOnMainThread(.failure(NetworkError.decodingError(error)), completion)
            }
            
        }.resume()
    }
    
    // ✅ Helper to switch to the main thread for UI-safe updates
    private func completeOnMainThread<T>(_ result: Result<T, Error>, _ completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}


struct AuthErrorResponse: Decodable {
    let error: String
    let description: String?
}

struct AuthResponse: Decodable {
    let token: String
}
