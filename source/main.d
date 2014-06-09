module main;

private {
    import vibe.d;
    import config;
}


shared static this() {
    setLogLevel(LogLevel.debug_);

    auto router = new URLRouter;
    router.get("/static/*", serveStaticFiles("./static/", new HTTPFileServerSettings("/static/")));
    router.get("/*", serveStaticFiles("./static/html/", new HTTPFileServerSettings("/")));

    //router.get("/", staticTemplate!("layout.dt")());

    auto config = Config.getInstance();


    //auto controller = new IterPatchController(config);
    //auto web = new IterPatchInterface(controller);
    //web.register(router);

    auto settings = new HTTPServerSettings;
    settings.sessionStore = new MemorySessionStore;
    settings.port = config.serverPort;

    listenHTTP(settings, router);

}
