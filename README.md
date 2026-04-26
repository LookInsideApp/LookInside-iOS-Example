# LookInsideExample-iOS

Minimal SwiftUI iOS app for end-to-end testing of [LookInsideServer](https://github.com/LookInsideApp/LookInsideServer) and the LookInside host inspector.

This repo is consumed as a submodule of the `LookInside-MonoRepo` private parent. It expects `LookInsideServer/` to be a sibling directory (resolved by SPM via `path: ../LookInsideServer`).

## Build

```bash
xcodegen generate          # regenerates LookInsideExample-iOS.xcodeproj from project.yml
xcodebuild -scheme LookInsideExample-iOS \
           -destination 'platform=iOS Simulator,name=iPhone 16' \
           -skipMacroValidation -allowProvisioningUpdates build
```

Or just open `LookInsideExample-iOS.xcodeproj` in Xcode and Run.

## Layout

- `Sources/LookInsideExampleApp/` — `@main` app, SwiftUI showcase, UIKit bridge, status tab
- `project.yml` — xcodegen spec; regenerate the `.xcodeproj` after edits with `xcodegen generate`

## E2E test workflow

1. Build & run this app on the iOS Simulator.
2. On the same Mac, run the `LookInside` host app from the parent monorepo.
3. The host should auto-discover the simulator app via Peertalk on ports `47164–47169`.
4. Click any view in the host to inspect the live UIKit hierarchy.
5. SwiftUI hierarchy inspection requires the unmerged `feat/swiftui-support` branch in `LookInside`.
