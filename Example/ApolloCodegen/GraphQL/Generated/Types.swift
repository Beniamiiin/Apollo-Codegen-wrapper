//  This file was automatically generated and should not be edited.

import Apollo

/// The access level to a repository
public enum RepositoryPermission: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Can read, clone, push, and add collaborators
  case admin
  /// Can read, clone and push
  case write
  /// Can read and clone
  case read
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ADMIN": self = .admin
      case "WRITE": self = .write
      case "READ": self = .read
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .admin: return "ADMIN"
      case .write: return "WRITE"
      case .read: return "READ"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: RepositoryPermission, rhs: RepositoryPermission) -> Bool {
    switch (lhs, rhs) {
      case (.admin, .admin): return true
      case (.write, .write): return true
      case (.read, .read): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}