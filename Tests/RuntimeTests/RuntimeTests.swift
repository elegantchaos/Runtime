import Testing
import Foundation
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
