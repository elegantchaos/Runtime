// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 06/03/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Canonical environment variable keys used by runtime helpers.
///
/// Use standard cases for common variables.
public enum EnvironmentKey: String, Sendable, Hashable {
  /// Executable search path entries.
  case path = "PATH"

  /// Current user's home directory path.
  case home = "HOME"

  /// Login shell path.
  case shell = "SHELL"

  /// Current user name.
  case user = "USER"

  /// Current working directory path.
  case pwd = "PWD"

  /// Temporary directory path.
  case tempDir = "TMPDIR"

  /// Locale language setting.
  case lang = "LANG"

  /// Preferred terminal type.
  case term = "TERM"

  /// Whether Xcode is running SwiftUI previews.
  case xcodeRunningForPreviews = "XCODE_RUNNING_FOR_PREVIEWS"

  /// Whether a UI test target is active.
  case uiTesting = "UITesting"
}
