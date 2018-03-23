//  This file was automatically generated and should not be edited.

import Apollo

public struct RepositoryInfo: GraphQLFragment {
  public static let fragmentString =
    "fragment RepositoryInfo on Repository {\n  __typename\n  createdAt\n  description\n  viewerPermission\n}"

  public static let possibleTypes = ["Repository"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
    GraphQLField("description", type: .scalar(String.self)),
    GraphQLField("viewerPermission", type: .scalar(RepositoryPermission.self)),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(createdAt: String, description: String? = nil, viewerPermission: RepositoryPermission? = nil) {
    self.init(snapshot: ["__typename": "Repository", "createdAt": createdAt, "description": description, "viewerPermission": viewerPermission])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Identifies the date and time when the object was created.
  public var createdAt: String {
    get {
      return snapshot["createdAt"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "createdAt")
    }
  }

  /// The description of the repository.
  public var description: String? {
    get {
      return snapshot["description"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "description")
    }
  }

  /// The users permission level on the repository. Will return null if authenticated as an GitHub App.
  public var viewerPermission: RepositoryPermission? {
    get {
      return snapshot["viewerPermission"] as? RepositoryPermission
    }
    set {
      snapshot.updateValue(newValue, forKey: "viewerPermission")
    }
  }
}