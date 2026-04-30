#if canImport(LookInsideServerStatic)
    import LookInsideServerStatic
#elseif canImport(LookinServer)
    import LookinServer
#endif

enum LookInsideServerRuntime {
    static var isLicensed: Bool {
        LookInsideServer.isLicensed
    }
}
