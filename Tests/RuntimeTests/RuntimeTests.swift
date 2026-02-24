import Testing
@testable import Runtime

@Test("AppInfo formats full version")
func appInfoFullVersionFormatting() {
  #expect(AppInfo.formatFullVersion(version: "1.2.3", build: "45", internalBuild: false) == "1.2.3 (45)")
  #expect(AppInfo.formatFullVersion(version: "1.2.3", build: "45", internalBuild: true) == "1.2.3 (45I)")
}

@Test("Platform current returns a stable variant")
func platformCurrentVariantIsKnown() {
  let variant = Platform.current.variant
  #expect(variant == .normal || variant == .simulator || variant == .catalyst)
}

@Test("Runtime snapshot aligns app and platform snapshots")
func runtimeSnapshotCoherent() {
  let runtime = Runtime()
  #expect(!runtime.app.version.isEmpty)
  #expect(runtime.platform == runtime.device.platform)
}
