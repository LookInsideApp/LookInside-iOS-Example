#if canImport(LookInsideServer)
    import LookInsideServer
#elseif canImport(LookinServer)
    import LookinServer
#endif

enum LookInsideServerRuntime {
    static var isLicensed: Bool {
        LookInsideServer.isLicensed
    }
}
