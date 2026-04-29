# LookInsideExample-iOS

> Internal demo fixture. Not for public distribution.

Minimal SwiftUI iOS app used as the end-to-end test target for [`LookInsideServer`](https://github.com/LookInsideApp/LookInsideServer) and the LookInside macOS host.

This repo is consumed as a submodule of the private `LookInside-MonoRepo` parent. It expects `LookInsideServer/` to sit as a sibling directory and resolves it via SwiftPM `path: ../LookInsideServer`.

---

## Build

```bash
xcodegen generate          # regenerate the .xcodeproj from project.yml
xcodebuild -scheme LookInsideExample-iOS \
           -destination 'platform=iOS Simulator,name=iPhone 16' \
           -skipMacroValidation -allowProvisioningUpdates build
```

Or open `LookInsideExample-iOS.xcodeproj` in Xcode and run.

Re-run `xcodegen generate` after editing `project.yml`.

---

## E2E flow

1. Build and run this app on the iOS Simulator.
2. On the same Mac, run the `LookInside` host app from the parent monorepo.
3. The host auto-discovers the simulator app via Peertalk on `47164–47169`.
4. Click any view in the host to inspect the live UIKit hierarchy.
5. SwiftUI hierarchy inspection requires the `feat/swiftui-support` branch in `LookInside`.

---

## Layout

| Path | Role |
| --- | --- |
| [`Sources/LookInsideExampleApp/`](Sources/LookInsideExampleApp/) | `@main` app, SwiftUI showcase, UIKit bridge, status tab |
| [`project.yml`](project.yml) | xcodegen spec — regenerate the `.xcodeproj` after edits |
| [`Makefile`](Makefile) | Convenience wrappers for the commands above |
