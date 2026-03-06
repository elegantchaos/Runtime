import Foundation

/// Application metadata captured from a bundle and process environment.
///
/// `AppInfo` intentionally keeps values simple and immutable so callers can pass
/// snapshots through app layers and tests without relying on global state.
public struct BundleInfo: Sendable {
  /// A string-projected snapshot of the source bundle info dictionary.
  public let info: [String: String]

  /// The best available application identifier.
  public let identifier: String

  /// The best available display name.
  public let name: String

  /// The executable name if available.
  public let executable: String

  /// The short marketing version string.
  public let version: String

  /// The build number string.
  public let build: String

  /// Version formatted as `version (build)`.
  public let fullVersion: String

  /// Creates app metadata for a specific bundle.
  /// - Parameters:
  ///   - bundle: Bundle to inspect.
  public init(bundle: Bundle = .main) {
    let info = bundle.infoDictionary?.mapValues({ String(describing:$0) }) ?? [:]

    self.info = info
    self.identifier = bundle.bundleIdentifier ?? "?"
    self.name = info[.bundleDisplayNameKey] ?? info[.bundleNameKey] ?? "?"
    self.executable = info[.bundleExecutableKey] ?? ""
    self.version = info[.bundleShortVersionStringKey] ?? "?"
    let rawBuild = info[.bundleVersionKey] ?? info[.buildKey] ?? "0"
    self.build = rawBuild == "BUILD" ? "xcode" : rawBuild
    let isInternalBuild = identifier.hasSuffix(".internal")
    self.fullVersion = Self.formatFullVersion(version: version, build: build, internalBuild: isInternalBuild)
  }

  /// Formats a full version string from core parts.
  /// - Parameters:
  ///   - version: Short version value.
  ///   - build: Build number string.
  ///   - internalBuild: Whether to append internal marker.
  /// - Returns: Formatted full version.
  public static func formatFullVersion(version: String, build: String, internalBuild: Bool) -> String {
    let suffix = internalBuild ? "I" : ""
    return "\(version) (\(build)\(suffix))"
  }
}

public extension Bundle {
  /// Runtime metadata for this bundle.
  var runtimeInfo: BundleInfo {
    BundleInfo(bundle: self)
  }
}
