import Foundation

#if canImport(UIKit)
  import UIKit
#endif

/// Unified runtime metadata snapshot for process, bundle, platform, and host details.
///
/// `Runtime` captures values once at initialization time so downstream code can
/// pass a stable value object instead of reading process globals repeatedly.
public struct Runtime: Sendable {
  /// Bundle metadata.
  public let bundle: BundleInfo

  /// Process metadata used to populate environment and host fields.
  public let process: ProcessInfo

  /// Host name reported by the process environment.
  public let hostName: String

  /// User-visible operating system name.
  public let systemName: String

  /// User-visible operating system version string.
  public let systemVersion: String

  /// Platform metadata.
  public let platform: Platform

  /// Optional device identifier.
  /// This is assigned once, and stored in the defaults.
  /// It may change if the user deletes their preferences or re-installs the app.
  /// It is intended only as a way to track values that are likely to be from the same user/device
  /// pair (eg for certain anonymous analytics), but it gives no strong guarantee of identity.
  public let deviceIdentifier: String?

  /// Whether this process is running in SwiftUI previews.
  public let isPreviewing: Bool

  /// Whether this build targets a simulator runtime.
  public let isSimulatorBuild: Bool

  /// Whether this compilation includes debug code paths.
  public let isDebugBuild: Bool

  /// Whether this looks like it is a UI test build.
  public let isUITestingBuild: Bool

  /// Whether this build is marked as internal by bundle identifier convention.
  public let isInternalBuild: Bool

  /// Whether this looks like a TestFlight build.
  public let isTestFlightBuild: Bool

  /// Environment variables captured at initialization.
  ///
  /// This dictionary is private to keep key usage explicit via `EnvironmentKey`
  /// or the `environment(_:)` helpers.
  private let environment: [String: String]

  /// Returns true when this is a production App Store style build.
  public var isAppStoreRelease: Bool {
    !isDebugBuild && !isSimulatorBuild && !isTestFlightBuild
  }

  /// Returns an environment variable value for a known key.
  /// - Parameter key: The environment key to look up.
  /// - Returns: Variable value if present, otherwise `nil`.
  public func environment(_ key: EnvironmentKey) -> String? {
    environment[key.rawValue]
  }

  /// Returns an environment variable value for a known key,
  /// normalized to lowercase. If the key is missing, we return
  /// the empty string.
  /// - Parameter key: The environment key to look up.
  /// - Returns: Normalized value if present, otherwise empty string.
  public func normalized(_ key: EnvironmentKey) -> String {
    let raw = environment[key.rawValue] ?? ""
    return raw.lowercased()
  }

  /// Returns true if an environment variable value for a known key
  /// contains a truthy value. Uses `NSString.boolValue`
  /// to determine truthyness.
  /// - Parameter key: The environment key to look up.
  /// - Returns: Normalized value if present, otherwise empty string.
  public func flag(_ key: EnvironmentKey) -> Bool {
    guard let raw = environment[key.rawValue] as? NSString else { return false }
    return raw.boolValue
  }

  /// Returns a bundle info value for a known key.
  /// - Parameter key: The bundle key to look up.
  /// - Returns: Bundle info value if present, otherwise `nil`.
  public func info(_ key: BundleKey) -> String? {
    bundle.info[key.rawValue]
  }

  /// Returns a bundle info value for an arbitrary key.
  /// - Parameter key: The bundle key to look up.
  /// - Returns: Bundle info value if present, otherwise `nil`.
  public func info(_ key: String) -> String? {
    bundle.info[key]
  }

  /// Creates an aggregate runtime snapshot.
  /// - Parameters:
  ///   - bundle: Bundle to inspect.
  ///   - processInfo: Process info source.
  public init(bundle: Bundle = .main, processInfo: ProcessInfo = .processInfo) {
    self.bundle = BundleInfo(bundle: bundle)
    self.process = processInfo
    self.environment = processInfo.environment
    self.platform = .current
    self.deviceIdentifier = Self.resolveDeviceIdentifier()

    #if os(iOS) || os(tvOS) || os(watchOS)
      // On Apple mobile platforms we do not need a real host name to start the app,
      // and querying one on first launch has proven suspicious enough to keep off
      // the cold-start path.
      self.hostName = bundle.bundleIdentifier ?? processInfo.processName
    #else
      self.hostName = processInfo.hostName
    #endif

    self.systemName = processInfo.operatingSystemVersionString
    self.systemVersion = processInfo.operatingSystemVersionString
    self.isPreviewing = environment[EnvironmentKey.xcodeRunningForPreviews.rawValue] == "1"
    self.isUITestingBuild = environment[EnvironmentKey.uiTesting.rawValue] == "YES"

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

    self.isInternalBuild = self.bundle.identifier.hasInternalBuildSuffix
    self.isTestFlightBuild = bundle.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
  }

  /// Defaults key used to persist the anonymous app-scoped device identifier.
  static let anonymousDeviceIdentifierDefaultsKey = "AnonymousDeviceID"

  /// Loads the anonymous device identifier from defaults, creating and persisting one if needed.
  static func resolveDeviceIdentifier(defaults: UserDefaults = .standard) -> String? {
    if let identifier = defaults.string(forKey: anonymousDeviceIdentifierDefaultsKey) {
      return identifier
    }

    let identifier = UUID().uuidString
    defaults.set(identifier, forKey: anonymousDeviceIdentifierDefaultsKey)
    return identifier
  }
}

public extension Runtime {
  /// Shared runtime snapshot for the current process, initialized on first access.
  static let shared = Runtime()
}
