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

```swift
import Runtime

let runtime = Runtime()

let path = runtime.environment(.path)
let shell = runtime.environment("SHELL")

let bundleVersion = runtime.info(.bundleVersion)
let displayName = runtime.info(.displayName)
```

## Validation

Run tests with:

```bash
swift test
```
