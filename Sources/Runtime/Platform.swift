import Foundation

/// A lightweight description of the current runtime platform.
public enum Platform: Sendable {
  /// macOS runtime, including catalyst or native variant.
  case macOS(MacVariant)
  /// iOS runtime.
  case iOS
  /// tvOS runtime.
  case tvOS
  /// watchOS runtime.
  case watchOS
  /// Linux runtime.
  case linux
  /// Windows runtime.
  case windows
  /// Unknown or unsupported runtime.
  case other

  /// Platform detected for the current compilation target.
  public static var current: Platform {
    #if os(macOS)
      #if targetEnvironment(macCatalyst)
        .macOS(.catalyst)
      #else
        .macOS(.normal)
      #endif
    #elseif os(iOS)
      .iOS
    #elseif os(tvOS)
      .tvOS
    #elseif os(watchOS)
      .watchOS
    #elseif os(Linux)
      .linux
    #elseif os(Windows)
      .windows
    #else
      .other
    #endif
  }

  /// Variant for macOS runtimes.
  public enum MacVariant: Sendable {
    /// Native macOS app runtime.
    case normal
    /// Mac Catalyst runtime.
    case catalyst
  }
}
