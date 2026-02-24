import Foundation

/// Combined runtime snapshot for app, device, and environment metadata.
///
/// Prefer `AppInfo`, `Device`, and `Platform` directly when only one facet is
/// needed. Use `Runtime.current` when a single aggregate value is convenient.
public struct Runtime: Sendable {
  /// Application metadata.
  public let app: AppInfo

  /// Device metadata.
  public let device: Device

  /// Platform metadata.
  public let platform: Platform

  /// Environment variables captured at initialization.
  public let environment: [String: String]

  /// Creates an aggregate runtime snapshot.
  /// - Parameters:
  ///   - bundle: Bundle to inspect.
  ///   - processInfo: Process info source.
  public init(bundle: Bundle = .main, processInfo: ProcessInfo = .processInfo) {
    self.app = AppInfo(bundle: bundle, processInfo: processInfo)
    self.device = Device(processInfo: processInfo)
    self.platform = .current
    self.environment = processInfo.environment
  }

  /// Convenience shared snapshot for common call sites.
  public static let current = Runtime()
}
