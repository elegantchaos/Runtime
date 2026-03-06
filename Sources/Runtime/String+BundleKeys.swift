// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 06/03/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public extension String {
  /// User-visible app name shown by the system.
  static let bundleDisplayNameKey = "CFBundleDisplayName"

  /// Human-readable bundle name.
  static let bundleNameKey = kCFBundleNameKey as String

  /// Executable file name key.
  static let bundleExecutableKey = kCFBundleExecutableKey as String

  /// Marketing version key.
  static let bundleShortVersionStringKey = "CFBundleShortVersionString"

  /// Build version key.
  static let bundleVersionKey = kCFBundleVersionKey as String

  /// Custom fallback build key used by some build pipelines.
  static let buildKey = "Build"
}
