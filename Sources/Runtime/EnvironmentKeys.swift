// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 06/03/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Canonical environment variable keys used by runtime helpers.
///
/// Use standard cases for common variables.
public struct EnvironmentKey: Sendable, RawRepresentable {
  public let rawValue: String
  
  public init(_ string: String) {
    self.init(rawValue: string)
  }

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
  
  /// Executable search path entries.
  static let path = EnvironmentKey("PATH")

  /// Current user's home directory path.
  static let home = EnvironmentKey("HOME")

  /// Login shell path.
  static let shell = EnvironmentKey("SHELL")

  /// Current user name.
  static let user = EnvironmentKey("USER")

  /// Current working directory path.
  static let pwd = EnvironmentKey("PWD")

  /// Temporary directory path.
  static let tempDir = EnvironmentKey("TMPDIR")

  /// Locale language setting.
  static let lang = EnvironmentKey("LANG")

  /// Preferred terminal type.
  static let term = EnvironmentKey("TERM")

  /// Whether Xcode is running SwiftUI previews.
  static let xcodeRunningForPreviews = EnvironmentKey("XCODE_RUNNING_FOR_PREVIEWS")

  /// Whether a UI test target is active.
  static let uiTesting = EnvironmentKey("UITesting")
}
