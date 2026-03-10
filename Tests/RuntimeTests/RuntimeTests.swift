import Foundation
import Testing

@testable import Runtime

@Test("AppInfo formats full version")
func appInfoFullVersionFormatting() {
  #expect(BundleInfo.formatFullVersion(version: "1.2.3", build: "45", internalBuild: false) == "1.2.3 (45)")
  #expect(BundleInfo.formatFullVersion(version: "1.2.3", build: "45", internalBuild: true) == "1.2.3 (45I)")
}

@Test("Platform current returns a stable variant")
func platformCurrentVariantIsKnown() {
  switch Platform.current {
    case .macOS(.normal), .macOS(.catalyst), .iOS, .tvOS, .watchOS, .linux, .windows, .other:
      #expect(Bool(true))
  }
}

@Test("Runtime snapshot aligns app and platform snapshots")
func runtimeSnapshotCoherent() {
  let runtime = Runtime()
  #expect(runtime.bundle.version == (runtime.info(.shortVersionString) ?? ""))
  #expect(!runtime.hostName.isEmpty)
  #expect(runtime.isAppStoreRelease == (!runtime.isDebugBuild && !runtime.isSimulatorBuild && !runtime.isTestFlightBuild))
}

@Test("Runtime info lookup supports enum and raw keys")
func runtimeBundleInfoLookup() {
  let runtime = Runtime()
  #expect(runtime.info(.shortVersionString) == runtime.info(BundleKey.shortVersionString.rawValue))
  #expect(runtime.info(.bundleVersion) == runtime.info(BundleKey.bundleVersion.rawValue))
  #expect(runtime.info("NON_EXISTENT_RUNTIME_BUNDLE_KEY_12345") == nil)
}

@Test("BundleKey raw values match CoreFoundation constants where available")
func bundleKeyCoreFoundationConstantParity() {
  #expect(BundleKey.bundleName.rawValue == (kCFBundleNameKey as String))
  #expect(BundleKey.executableName.rawValue == (kCFBundleExecutableKey as String))
  #expect(BundleKey.identifier.rawValue == (kCFBundleIdentifierKey as String))
  #expect(BundleKey.bundleVersion.rawValue == (kCFBundleVersionKey as String))
  #expect(BundleKey.developmentRegion.rawValue == (kCFBundleDevelopmentRegionKey as String))
  #expect(BundleKey.localizations.rawValue == (kCFBundleLocalizationsKey as String))
  #expect(BundleKey.infoDictionaryVersion.rawValue == (kCFBundleInfoDictionaryVersionKey as String))
}

@Test("EnvironmentKey raw values match expected names")
func environmentKeyRawValues() {
  #expect(EnvironmentKey.path.rawValue == "PATH")
  #expect(EnvironmentKey.home.rawValue == "HOME")
  #expect(EnvironmentKey.shell.rawValue == "SHELL")
  #expect(EnvironmentKey.user.rawValue == "USER")
  #expect(EnvironmentKey.pwd.rawValue == "PWD")
  #expect(EnvironmentKey.tempDir.rawValue == "TMPDIR")
  #expect(EnvironmentKey.lang.rawValue == "LANG")
  #expect(EnvironmentKey.term.rawValue == "TERM")
  #expect(EnvironmentKey.xcodeRunningForPreviews.rawValue == "XCODE_RUNNING_FOR_PREVIEWS")
  #expect(EnvironmentKey.uiTesting.rawValue == "UITesting")
}

@Test("Runtime environment lookup parity for known keys")
func runtimeEnvironmentNormalized() {
  let runtime = Runtime()
  let home =
    ProcessInfo.processInfo
    .environment["HOME"]?
    .lowercased()
    ?? ""
  #expect(runtime.normalized(.home) == home)
  #expect(runtime.normalized(EnvironmentKey("NONEXISTANT")).isEmpty)
}

@Test("Bundle runtimeInfo extension matches direct initializer")
func bundleRuntimeInfoExtensionParity() {
  let fromExtension = Bundle.main.runtimeInfo
  let fromInit = BundleInfo(bundle: .main)

  #expect(fromExtension.identifier == fromInit.identifier)
  #expect(fromExtension.name == fromInit.name)
  #expect(fromExtension.executable == fromInit.executable)
  #expect(fromExtension.version == fromInit.version)
  #expect(fromExtension.build == fromInit.build)
  #expect(fromExtension.fullVersion == fromInit.fullVersion)
}

@Test("Internal build suffix helper detects internal naming convention")
func internalBuildSuffixHelper() {
  #expect("com.example.app.internal".hasInternalBuildSuffix)
  #expect(!"com.example.app".hasInternalBuildSuffix)
}

@Test("Runtime decodes expected Info.plist values from fixture bundle")
func runtimeFixtureBundleInfoPlistDecoding() throws {
  let fixtureURL = try #require(Bundle.module.url(forResource: "Fixture", withExtension: "bundle"))
  let fixture = try #require(Bundle(url: fixtureURL))
  let runtime = Runtime(bundle: fixture)
  let info = fixture.infoDictionary?.mapValues({ String(describing: $0) }) ?? [:]

  #expect(runtime.info(.displayName) == info[BundleKey.displayName.rawValue])
  #expect(runtime.info(.bundleName) == info[BundleKey.bundleName.rawValue])
  #expect(runtime.info(.executableName) == info[BundleKey.executableName.rawValue])
  #expect(runtime.info(.shortVersionString) == info[BundleKey.shortVersionString.rawValue])
  #expect(runtime.info(.bundleVersion) == info[BundleKey.bundleVersion.rawValue])
  #expect(runtime.info(.build) == info[BundleKey.build.rawValue])
  #expect(runtime.info(.spokenName) == info[BundleKey.spokenName.rawValue])
  #expect(runtime.info(.urlName) == info[BundleKey.urlName.rawValue])
  #expect(runtime.info(.principalClass) == info[BundleKey.principalClass.rawValue])

  #expect(runtime.bundle.name == (info[BundleKey.displayName.rawValue] ?? info[BundleKey.bundleName.rawValue] ?? ""))
  #expect(runtime.bundle.executable == (info[BundleKey.executableName.rawValue] ?? ""))
  #expect(runtime.bundle.version == (info[BundleKey.shortVersionString.rawValue] ?? ""))

  let expectedBuild = (info[BundleKey.bundleVersion.rawValue] ?? info[BundleKey.build.rawValue] ?? "0")
  #expect(runtime.bundle.build == (expectedBuild == "BUILD" ? "xcode" : expectedBuild))
  #expect(runtime.bundle.identifier == (fixture.bundleIdentifier ?? ""))
  #expect(runtime.isInternalBuild == runtime.bundle.identifier.hasInternalBuildSuffix)
}
