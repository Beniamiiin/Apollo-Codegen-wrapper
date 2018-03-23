//  This file was automatically generated and should not be edited.

import Apollo

public final class RepositoryQuery: GraphQLQuery {
  public static let operationString =
    "query Repository {\n  viewer {\n    __typename\n    repository(name: \"Apollo-Codegen-wrapper\") {\n      __typename\n      ...RepositoryInfo\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(RepositoryInfo.fragmentString) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(viewer: Viewer) {
      self.init(snapshot: ["__typename": "Query", "viewer": viewer.snapshot])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(snapshot: snapshot["viewer"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("repository", arguments: ["name": "Apollo-Codegen-wrapper"], type: .object(Repository.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(repository: Repository? = nil) {
        self.init(snapshot: ["__typename": "User", "repository": repository.flatMap { (value: Repository) -> Snapshot in value.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Find Repository.
      public var repository: Repository? {
        get {
          return (snapshot["repository"] as? Snapshot).flatMap { Repository(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "repository")
        }
      }

      public struct Repository: GraphQLSelectionSet {
        public static let possibleTypes = ["Repository"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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

        public var fragments: Fragments {
          get {
            return Fragments(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }

        public struct Fragments {
          public var snapshot: Snapshot

          public var repositoryInfo: RepositoryInfo {
            get {
              return RepositoryInfo(snapshot: snapshot)
            }
            set {
              snapshot += newValue.snapshot
            }
          }
        }
      }
    }
  }
}