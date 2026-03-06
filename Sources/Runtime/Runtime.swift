import Foundation

#if canImport(UIKit)
  import UIKit
#endif

/// Unified snapshot of the runtime environment.
///
/// Includes values harvested from the process info, bundle info, build environment, and
/// host operating system.
public struct Runtime: Sendable {
  /// Bundle metadata.
  public let info: BundleInfo

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
  public let variables: [String: String]

  /// Returns true when this is a production App Store style build.
  public var isAppStoreRelease: Bool {
    !isDebugBuild && !isSimulatorBuild && !isTestFlightBuild
  }

  /// Creates an aggregate runtime snapshot.
  /// - Parameters:
  ///   - bundle: Bundle to inspect.
  ///   - processInfo: Process info source.
  public init(bundle: Bundle = .main, processInfo: ProcessInfo = .processInfo) {
    self.info = BundleInfo(bundle: bundle)
    self.hostName = processInfo.hostName
    self.platform = .current

    #if canImport(UIKit)
      let current = UIDevice.current
      self.systemName = current.systemName
      self.systemVersion = current.systemVersion
      self.identifier = current.identifierForVendor?.uuidString
    #else
      self.systemName = processInfo.operatingSystemVersionString
      self.systemVersion = processInfo.operatingSystemVersionString
      self.deviceIdentifier = nil
    #endif

    self.isPreviewing = processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    self.isUITestingBuild = processInfo.environment["UITesting"] == "YES"

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

    self.isInternalBuild = self.info.identifier.hasSuffix(".internal")
    self.isTestFlightBuild = bundle.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    self.variables = processInfo.environment
  }
}
