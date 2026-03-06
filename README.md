# Environment

This package provides a unified view of the current runtime environment.

This includes information gleaned from:
- the process environment (`ProcessInfo.processInfo`)
- the primary bundle (`Bundle.main`, or a supplied alternative)
- the current working directory (`FileManager.default.currentDirectoryPath`)

