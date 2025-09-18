//
//  APIService.swift
//  NUK Unofficial APP
//
//  Created by Hao-Quan Liu on 2025/1/25.
//

import Foundation
import SwiftUI

enum APIError: Error {
    case invalidURL
    case noInternet
    case networkError(Error)
    case invalidResponse
    case serverError(statusCode: Int, errorMessage: String?)
    case noData
    case decodingError(Error)
    case unknown(Error)
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "無法連線至伺服器，請稍後再試。"
        case .noInternet:
            return "偵測不到網路連線，請確認您的網路狀態。"
        case .networkError:
            return "網路發生錯誤，請稍後再試。"
        case .invalidResponse:
            return "伺服器回應異常，請稍後再試。"
        case .serverError(let statusCode, let errorMessage):
            if let errorMessage = errorMessage {
                return errorMessage
            }
            return "伺服器發生錯誤（狀態碼：\(statusCode)），請稍後再試。"
        case .noData:
            return "目前沒有可用的資料，請稍後再試。"
        case .decodingError:
            return "資料處理時發生錯誤，請稍後再試。"
        case .unknown:
            return "發生未知錯誤，請稍後再試。"
        }
    }
}

class APIService {
    static let shared: APIService = APIService()
    private let baseURL: String = Config.baseURL
    private let session: URLSession = URLSession.shared
    
    private func performRequest<T: Decodable>(request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                var errorMessage: String?
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonDictionary = jsonObject as? [String: Any] {
                    errorMessage = jsonDictionary["error"] as? String
                }
                throw APIError.serverError(statusCode: httpResponse.statusCode, errorMessage: errorMessage)
            }

            guard !data.isEmpty else {
                throw APIError.noData
            }
            
            do {
                let jsonDecoder: JSONDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                return try jsonDecoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let apiError as APIError {
            throw apiError
        } catch {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                throw APIError.noInternet
            } else {
                throw APIError.networkError(error)
            }
        }
    }
    
    func fetch<T: Decodable>(endpoint: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard var components: URLComponents = URLComponents(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        components.queryItems = queryItems
        
        guard let url: URL = components.url else {
            throw APIError.invalidURL
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "NULL", forHTTPHeaderField: "NUKAPP-App-Version")
        request.setValue(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "NULL", forHTTPHeaderField: "NUKAPP-Build-Version")
        
        return try await performRequest(request: request)
    }
    
    func post<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
        guard let url: URL = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "NULL", forHTTPHeaderField: "NUKAPP-App-Version")
        request.setValue(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "NULL", forHTTPHeaderField: "NUKAPP-Build-Version")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw APIError.decodingError(error)
        }

        return try await performRequest(request: request)
    }
}
