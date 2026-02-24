import Foundation

/// Application metadata captured from a bundle and process environment.
///
/// `AppInfo` intentionally keeps values simple and immutable so callers can pass
/// snapshots through app layers and tests without relying on global state.
public struct AppInfo: Sendable {
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

  /// Whether this build is marked as internal by bundle identifier convention.
  public let isInternalBuild: Bool

  /// Whether this process is running in SwiftUI previews.
  public let isPreviewing: Bool

  /// Whether this build targets a simulator runtime.
  public let isSimulatorBuild: Bool

  /// Whether this compilation includes debug code paths.
  public let isDebugBuild: Bool

  /// Whether this looks like a TestFlight build.
  public let isTestFlightBuild: Bool

  /// Creates app metadata for a specific bundle.
  /// - Parameters:
  ///   - bundle: Bundle to inspect.
  ///   - processInfo: Process info for environment-derived flags.
  public init(bundle: Bundle = .main, processInfo: ProcessInfo = .processInfo) {
    let rawInfo = bundle.infoDictionary ?? [:]
    self.info = rawInfo.reduce(into: [:]) { partial, entry in
      partial[entry.key] = String(describing: entry.value)
    }

    self.identifier = bundle.bundleIdentifier ?? "?"

    self.name = (rawInfo["CFBundleDisplayName"] as? String)
      ?? (rawInfo["CFBundleName"] as? String)
      ?? "?"

    self.executable = (rawInfo["CFBundleExecutable"] as? String) ?? ""

    self.version = (rawInfo["CFBundleShortVersionString"] as? String) ?? "?"

    let rawBuild = (rawInfo["CFBundleVersion"] as? String)
      ?? (rawInfo["Build"] as? String)
      ?? "0"
    self.build = rawBuild == "BUILD" ? "xcode" : rawBuild

    self.isInternalBuild = identifier.hasSuffix(".internal")
    self.isPreviewing = processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

    #if targetEnvironment(simulator)
      self.isSimulatorBuild = true
    #else
      self.isSimulatorBuild = false
    #endif

    #if DEBUG
      self.isDebugBuild = true
    #else
      self.isDebugBuild = false
    #endif

    #if canImport(Foundation)
      self.isTestFlightBuild = bundle.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    #else
      self.isTestFlightBuild = false
    #endif

    self.fullVersion = Self.formatFullVersion(version: version, build: build, internalBuild: isInternalBuild)
  }

  /// Returns true when this is a production App Store style build.
  public var isAppStoreRelease: Bool {
    !isDebugBuild && !isSimulatorBuild && !isTestFlightBuild
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
  var runtimeInfo: AppInfo {
    AppInfo(bundle: self)
  }
}
