import Foundation

/// Immutable snapshot of bundle metadata used by `Runtime`.
///
/// `BundleInfo` normalizes key values into strings so callers can consume
/// metadata consistently across platforms and test fixtures, even when bundle
/// values are absent.
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

  /// Creates bundle metadata for a specific bundle.
  /// - Parameters:
  ///   - bundle: Bundle to inspect.
  public init(bundle: Bundle = .main) {
    let info = bundle.infoDictionary?.mapValues({ String(describing: $0) }) ?? [:]

    self.info = info
    self.identifier = bundle.bundleIdentifier ?? ""
    self.name = info[BundleKey.displayName.rawValue] ?? info[BundleKey.bundleName.rawValue] ?? ""
    self.executable = info[BundleKey.executableName.rawValue] ?? ""
    self.version = info[BundleKey.shortVersionString.rawValue] ?? ""
    let rawBuild = info[BundleKey.bundleVersion.rawValue] ?? info[BundleKey.build.rawValue] ?? "0"
    self.build = rawBuild == "BUILD" ? "xcode" : rawBuild
    self.fullVersion = Self
      .formatFullVersion(
        version: version,
        build: build,
        internalBuild: identifier.hasInternalBuildSuffix
      )
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

extension String {
  /// Is this string suffixed with our standard "internal build" marker?
  var hasInternalBuildSuffix: Bool {
    hasSuffix(".internal")
  }
}
