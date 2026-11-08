// ServiceError.swift
// By Artem Golovanev

import Core
import Foundation

public enum ServiceError: LocalizedError {
    case invalidResponse
    case requestError(Int)
    
    public var errorDescription: String? {
        switch self {
            case .invalidResponse:
                Strings.invalidResponse
            case let .requestError(code):
                Strings.serverError(code)
        }
    }
}
