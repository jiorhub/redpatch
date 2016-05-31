module main;

private {
    import vibe.d;
    import config;
    import middleware;
    import message;
}


struct Project {
    string title;
}


shared static this() {
    setLogLevel(LogLevel.debug_);

    auto router = new URLRouter;
    router.get("/", staticRedirect("/index.html"));
    router.get("/static/*", serveStaticFiles("./static/", new HTTPFileServerSettings("/static/")));
    router.get("/*", serveStaticFiles("./static/html/", new HTTPFileServerSettings("/")));

    //registerRestInterface(router, new RedPatchAPI(), "/api");

    auto config = Config.getInstance();

    auto container = router.createMiddlewareContainer();
    container.addMiddleware(new PermissionMiddleware((req, res) {
        res.writeJsonBody(new ErrorMessage("Permission denied!"));
    }));

    //auto controller = new IterPatchController(config);
    //auto web = new IterPatchInterface(controller);
    //web.register(router);

    auto settings = new HTTPServerSettings;
    settings.sessionStore = new MemorySessionStore;
    settings.port = config.serverPort;

    listenHTTP(settings, container);
}
