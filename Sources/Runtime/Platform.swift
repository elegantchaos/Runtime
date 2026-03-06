import Foundation

/// A lightweight description of the current runtime platform.
public enum Platform: Sendable {
  case macOS(MacVariant)
  case iOS
  case tvOS
  case watchOS
  case linux
  case windows
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

  /// macOS variant
  public enum MacVariant: Sendable {
    case normal
    case catalyst
  }

}
