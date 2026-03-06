// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 06/03/2026.
//  Copyright © 2026 Elegant Chaos Limited. All rights reserved.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/// Canonical bundle info dictionary keys used by runtime helpers.
public enum BundleKey: String, Sendable, Hashable {
  /// Bundle identifier value.
  case identifier = "CFBundleIdentifier"

  /// User-visible app name shown by the system.
  case displayName = "CFBundleDisplayName"

  /// Human-readable bundle name.
  case bundleName = "CFBundleName"

  /// Executable file name key.
  case executableName = "CFBundleExecutable"

  /// Marketing version key.
  case shortVersionString = "CFBundleShortVersionString"

  /// Build version key.
  case bundleVersion = "CFBundleVersion"

  /// Bundle package type value.
  case packageType = "CFBundlePackageType"

  /// Bundle info dictionary schema version.
  case infoDictionaryVersion = "CFBundleInfoDictionaryVersion"

  /// Development language region.
  case developmentRegion = "CFBundleDevelopmentRegion"

  /// Available localization list.
  case localizations = "CFBundleLocalizations"

  /// Spoken app name for text-to-speech.
  case spokenName = "CFBundleSpokenName"

  /// URL type definitions.
  case urlTypes = "CFBundleURLTypes"

  /// URL type display name.
  case urlName = "CFBundleURLName"

  /// URL schemes for deep links.
  case urlSchemes = "CFBundleURLSchemes"

  /// Launch storyboard file name.
  case launchStoryboardName = "UILaunchStoryboardName"

  /// Main storyboard file name.
  case mainStoryboardFile = "UIMainStoryboardFile"

  /// Scene manifest configuration.
  case applicationSceneManifest = "UIApplicationSceneManifest"

  /// Minimum iOS version requirement.
  case minimumOSVersion = "MinimumOSVersion"

  /// Minimum macOS version requirement.
  case lsMinimumSystemVersion = "LSMinimumSystemVersion"

  /// Principal class name.
  case principalClass = "NSPrincipalClass"

  /// App Transport Security policy dictionary.
  case appTransportSecurity = "NSAppTransportSecurity"

  /// Human-readable copyright notice.
  case humanReadableCopyright = "NSHumanReadableCopyright"

  /// Extension metadata dictionary.
  case extensionPoint = "NSExtension"

  /// Custom fallback build key used by some build pipelines.
  case build = "Build"
}
