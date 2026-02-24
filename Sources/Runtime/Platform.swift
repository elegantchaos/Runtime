import Foundation

/// A lightweight description of the current runtime platform.
public struct Platform: Sendable, Equatable {
  /// Base operating system family.
  public enum Base: Sendable {
    case macOS
    case iOS
    case tvOS
    case watchOS
    case linux
    case windows
    case other
  }

  /// Runtime variant on top of a base platform.
  public enum Variant: Sendable {
    case normal
    case simulator
    case catalyst
  }

  /// The current base platform.
  public let base: Base

  /// The current runtime variant.
  public let variant: Variant

  /// Constructs a platform value with explicit base and variant.
  public init(base: Base, variant: Variant) {
    self.base = base
    self.variant = variant
  }

  /// Platform detected for the current compilation target.
  public static var current: Platform {
    #if os(macOS)
      #if targetEnvironment(macCatalyst)
        .init(base: .macOS, variant: .catalyst)
      #else
        .init(base: .macOS, variant: .normal)
      #endif
    #elseif os(iOS)
      #if targetEnvironment(simulator)
        .init(base: .iOS, variant: .simulator)
      #else
        .init(base: .iOS, variant: .normal)
      #endif
    #elseif os(tvOS)
      #if targetEnvironment(simulator)
        .init(base: .tvOS, variant: .simulator)
      #else
        .init(base: .tvOS, variant: .normal)
      #endif
    #elseif os(watchOS)
      #if targetEnvironment(simulator)
        .init(base: .watchOS, variant: .simulator)
      #else
        .init(base: .watchOS, variant: .normal)
      #endif
    #elseif os(Linux)
      .init(base: .linux, variant: .normal)
    #elseif os(Windows)
      .init(base: .windows, variant: .normal)
    #else
      .init(base: .other, variant: .normal)
    #endif
  }

  /// True when the runtime is simulator-based.
  public var isSimulator: Bool {
    variant == .simulator
  }
}
