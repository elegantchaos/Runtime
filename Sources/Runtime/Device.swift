import Foundation

#if canImport(UIKit)
  import UIKit
#endif

/// Snapshot of runtime host and device metadata.
public struct Device: Sendable {
  /// Singleton convenience for the current process context.
  public static let main = Device()

  /// Host name reported by the process environment.
  public let hostName: String

  /// User-visible operating system name.
  public let systemName: String

  /// User-visible operating system version string.
  public let systemVersion: String

  /// Current platform classification.
  public let platform: Platform

  /// Optional installation/device identifier.
  public let identifier: String?

  /// Creates a snapshot from process and platform metadata.
  /// - Parameter processInfo: Process info source.
  public init(processInfo: ProcessInfo = .processInfo) {
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
      self.identifier = nil
    #endif
  }
}
