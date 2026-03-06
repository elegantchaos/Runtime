import Foundation

#if canImport(UIKit)
  import UIKit
#endif

/// Unified snapshot of the runtime environment.
///
/// Includes values harvested from the process info, bundle info, build environment, and
/// host operating system.
@dynamicMemberLookup
public struct Runtime: Sendable {
  /// Bundle metadata.
  public let bundle: BundleInfo

  /// Process metadata.
  public let process: ProcessInfo
  
  /// Host name reported by the process environment.
  public let hostName: String

  /// User-visible operating system name.
  public let systemName: String

  /// User-visible operating system version string.
  public let systemVersion: String

  /// Platform metadata.
  public let platform: Platform

  /// Optional installation/device identifier.
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
  private let environment: [String: String]

  /// Returns true when this is a production App Store style build.
  public var isAppStoreRelease: Bool {
    !isDebugBuild && !isSimulatorBuild && !isTestFlightBuild
  }

  /// Returns an environment variable by dynamic member name.
  ///
  /// This allows `runtime.PATH` style access as a shorthand for
  /// `runtime.environment("PATH")`.
  /// - Parameter member: Environment variable key.
  /// - Returns: Variable value if present, otherwise `nil`.
  public subscript(dynamicMember member: String) -> String? {
    environment[member]
  }

  /// Returns an environment variable value for a known key.
  /// - Parameter key: The environment key to look up.
  /// - Returns: Variable value if present, otherwise `nil`.
  public func environment(_ key: EnvironmentKey) -> String? {
    environment[key.rawValue]
  }

  /// Returns an environment variable value for an arbitrary key.
  /// - Parameter key: The environment key to look up.
  /// - Returns: Variable value if present, otherwise `nil`.
  public func environment(_ key: String) -> String? {
    environment[key]
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
    self.hostName = processInfo.hostName
    self.environment = processInfo.environment
    self.platform = .current

    #if canImport(UIKit)
      let current = UIDevice.current
      self.systemName = current.systemName
      self.systemVersion = current.systemVersion
      self.deviceIdentifier = current.identifierForVendor?.uuidString
    #else
      self.systemName = processInfo.operatingSystemVersionString
      self.systemVersion = processInfo.operatingSystemVersionString
      self.deviceIdentifier = nil
    #endif

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

    self.isInternalBuild = self.bundle.identifier.hasSuffix(".internal")
    self.isTestFlightBuild = bundle.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
  }
}
