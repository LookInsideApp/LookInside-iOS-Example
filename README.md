# LookInside-iOS-Example

> Public SwiftUI demo fixture for trying LookInside end to end.

Minimal SwiftUI iOS app used as the end-to-end test target for the LookInside macOS host and the prebuilt server runtime published by [`LookInside-Release`](https://github.com/LookInsideApp/LookInside-Release).

By default this project consumes the public `LookInsideServerStatic` SwiftPM binary product from `LookInside-Release`, so it can build without access to the private `LookInside-Server` source checkout. Monorepo maintainers can temporarily switch the package dependency to a local `../LookInside-Server` checkout when developing the server itself.

---

## Build

```bash
xcodebuild -scheme LookInsideExample-iOS \
           -project LookInsideExample-iOS.xcodeproj \
           -destination 'platform=iOS Simulator,name=iPhone 16' \
           -skipMacroValidation -allowProvisioningUpdates build
```

Or open `LookInsideExample-iOS.xcodeproj` in Xcode and run.

---

## E2E flow

1. Build and run this app on the iOS Simulator.
2. On the same Mac, run the `LookInside` host app from the parent monorepo.
3. The host auto-discovers the simulator app via Peertalk on `47164–47169`.
4. Click any view in the host to inspect the live UIKit hierarchy.
5. SwiftUI hierarchy inspection requires an activated host so the host can load the `LookInsideExtraSwiftUserInterfaceSupport` XCFramework served by `LookInside-Release`.

---

## Layout

| Path                                                                  | Role                                                    |
| --------------------------------------------------------------------- | ------------------------------------------------------- |
| [`Sources/LookInsideExampleApp/`](Sources/LookInsideExampleApp/)      | `@main` app, SwiftUI showcase, UIKit bridge, status tab |
| [`LookInsideExample-iOS.xcodeproj`](LookInsideExample-iOS.xcodeproj/) | Hand-maintained Xcode project                           |
| [`Makefile`](Makefile)                                                | Convenience wrappers around `xcodebuild`                |
