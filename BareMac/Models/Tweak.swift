import Foundation

struct Tweak: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let description: String
    let category: String
    let platform: String
    let scope: String
    let riskLevel: String
    let supportedOS: [String]?
    let apply: [TweakOperation]
    let revert: [TweakOperation]
    let parameters: [TweakParameter]? // Optional list of user-configurable parameters
    
    init(id: String, name: String, description: String, category: String, platform: String, scope: String, riskLevel: String, supportedOS: [String]? = nil, apply: [TweakOperation], revert: [TweakOperation], parameters: [TweakParameter]? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.platform = platform
        self.scope = scope
        self.riskLevel = riskLevel
        self.supportedOS = supportedOS
        self.apply = apply
        self.revert = revert
        self.parameters = parameters
    }
}

struct TweakParameter: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let type: ParameterType
    let defaultValue: AnyCodable
    let min: Double?
    let max: Double?
}

enum ParameterType: String, Codable, Hashable {
    case string, bool, int, float
}

struct TweakOperation: Codable, Hashable {
    let type: String // "defaults", "shell", "admin"
    // For defaults:
    let domain: String?
    let key: String?
    let value: AnyCodable? // Default/Static value
    let parameterRef: String? // ID of the parameter to substitute for this value
    // For shell/admin:
    let command: String?
    
    init(type: String, domain: String? = nil, key: String? = nil, value: AnyCodable? = nil, parameterRef: String? = nil, command: String? = nil) {
        self.type = type
        self.domain = domain
        self.key = key
        self.value = value
        self.parameterRef = parameterRef
        self.command = command
    }
}

// Helper for decoding mixed types in JSON
enum AnyCodable: Codable, Hashable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(AnyCodable.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AnyCodable"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x): try container.encode(x)
        case .bool(let x): try container.encode(x)
        case .int(let x): try container.encode(x)
        case .double(let x): try container.encode(x)
        }
    }
    
    var anyValue: Any {
        switch self {
        case .string(let x): return x
        case .bool(let x): return x
        case .int(let x): return x
        case .double(let x): return x
        }
    }
}
