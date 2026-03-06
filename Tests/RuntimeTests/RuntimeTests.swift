import Testing
@testable import Runtime

@Test("AppInfo formats full version")
func appInfoFullVersionFormatting() {
  #expect(BundleInfo.formatFullVersion(version: "1.2.3", build: "45", internalBuild: false) == "1.2.3 (45)")
  #expect(BundleInfo.formatFullVersion(version: "1.2.3", build: "45", internalBuild: true) == "1.2.3 (45I)")
}

@Test("Platform current returns a stable variant")
func platformCurrentVariantIsKnown() {
  let variant = Platform.current.variant
  #expect(variant == .normal || variant == .simulator || variant == .catalyst)
}

@Test("Runtime snapshot aligns app and platform snapshots")
func runtimeSnapshotCoherent() {
  let runtime = Runtime()
  #expect(!runtime.info.version.isEmpty)
  #expect(!runtime.hostName.isEmpty)
  #expect(runtime.isAppStoreRelease == (!runtime.isDebugBuild && !runtime.isSimulatorBuild && !runtime.isTestFlightBuild))
}
