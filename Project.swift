import Foundation
import ProjectDescription

let targetName = "LookInsideExample-iOS"
let localServerPath = Environment.lookinsideServerPath.getString(default: "")
    .trimmingCharacters(in: .whitespacesAndNewlines)

let usesLocalServer = !localServerPath.isEmpty
let localServerPackagePath: ProjectDescription.Path = localServerPath.hasPrefix("/")
    ? .path(localServerPath)
    : .relativeToManifest(localServerPath)
let serverPackage: Package = usesLocalServer
    ? .local(path: localServerPackagePath)
    : .remote(
        url: "https://github.com/LookInsideApp/LookInside-Release.git",
        requirement: .upToNextMajor(from: "0.1.10")
    )
let serverProduct = usesLocalServer ? "LookinServer" : "LookInsideServerStatic"

let project = Project(
    name: targetName,
    organizationName: "LookInside",
    packages: [
        serverPackage,
    ],
    settings: .settings(
        base: [
            "CODE_SIGNING_ALLOWED": "YES",
            "CODE_SIGNING_ALLOWED[sdk=iphoneos*]": "NO",
            "CODE_SIGNING_REQUIRED": "NO",
            "CODE_SIGN_IDENTITY": "-",
            "CODE_SIGN_IDENTITY[sdk=iphoneos*]": "",
            "CODE_SIGN_STYLE": "Manual",
            "DEVELOPMENT_TEAM": "",
            "ENABLE_USER_SCRIPT_SANDBOXING": "NO",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SDKROOT": "iphoneos",
            "SWIFT_VERSION": "5.10",
        ],
        debug: [
            "DEBUG_INFORMATION_FORMAT": "dwarf",
            "ENABLE_TESTABILITY": "YES",
            "ONLY_ACTIVE_ARCH": "YES",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
        ],
        release: [
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "ENABLE_NS_ASSERTIONS": "NO",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-O",
        ],
        defaultSettings: .recommended,
        defaultConfiguration: "Debug"
    ),
    targets: [
        .target(
            name: targetName,
            destinations: [.iPhone, .iPad],
            product: .app,
            productName: targetName,
            bundleId: "app.lookinside.example.ios",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .file(path: "Sources/LookInsideExampleApp/Info.plist"),
            sources: [
                "Sources/LookInsideExampleApp/**/*.swift",
            ],
            dependencies: [
                .package(product: serverProduct),
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "CODE_SIGN_IDENTITY": "iPhone Developer",
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/Frameworks",
                    ],
                    "PRODUCT_BUNDLE_IDENTIFIER": "app.lookinside.example.ios",
                    "SDKROOT": "iphoneos",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                ],
                defaultSettings: .recommended
            )
        ),
    ],
    schemes: [
        .scheme(
            name: targetName,
            shared: true,
            buildAction: .buildAction(targets: [.target(targetName)]),
            runAction: .runAction(configuration: "Debug", executable: .target(targetName)),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
