# Runtime

`Runtime` is a Swift package that exposes a small, explicit API for runtime
metadata and environment lookups.

## What It Captures

- Process metadata (`ProcessInfo`)
- Environment variables (`[String: String]`, via typed and raw lookup APIs)
- Bundle metadata (`BundleInfo`)
- Platform and host details (`Platform`, host name, OS version, device identifier)
- Build-context flags (debug/simulator/preview/UI-test/internal/TestFlight)

## Core Types

- `Runtime`: aggregate snapshot and lookup entry point
- `BundleInfo`: normalized bundle values plus formatted full version
- `BundleKey`: common bundle info dictionary keys
- `EnvironmentKey`: common process environment keys
- `Platform`: platform classification with macOS variant

## Usage

Direct properties are defined on `Runtime` for access to commonly
used information:

```swift
import Runtime

let runtime = Runtime()

// Prefer direct properties for common runtime metadata.
let appVersion = runtime.bundle.version
let build = runtime.bundle.build
let isDebug = runtime.isDebugBuild
let isPreview = runtime.isPreviewing
let platform = runtime.platform
let host = runtime.hostName
let osVersion = runtime.systemVersion
```

You can also read arbitrary keys from the bundle's info dictionary,
and the process environment dictionary:

```swift
import Runtime

let runtime = Runtime()

let path = runtime.environment(.path)
let shell = runtime.environment("SHELL")
let bundleVersion = runtime.info(.bundleVersion)
let displayName = runtime.info(.displayName)
```
