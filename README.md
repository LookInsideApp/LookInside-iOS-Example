# LookInside-Example

This is a ready-to-run demo app for trying LookInside on iOS and macOS.

It has three SwiftUI screens: Music, Feed, and Chat. Run the app, open LookInside on your Mac, and inspect the live UI.

## Run it

iOS Simulator:

```bash
make run
```

macOS:

```bash
make run-mac
```

You can also open `LookInsideExample.xcodeproj` in Xcode and press Run.

## Build only

```bash
make build-sim
make build-mac
```

## What is inside

| Path | What it is |
| ---- | ---------- |
| `Sources/LookInsideExampleApp/` | The demo app screens |
| `LookInsideExample.xcodeproj` | The Xcode project |
| `Project.swift` | Tuist project setup |
| `Configuration/` | Build settings |

LookInside continues the work of [`LookinServer`](https://github.com/QMUI/LookinServer), the original iOS view debugger runtime.
