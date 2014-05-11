module main;

private {
    import vibe.d;
    import config;
    import itercontroller;
    import iterinterface;
}

shared static this() {
    //setLogLevel(LogLevel.debug_);

    auto config = new IterPatchConfig();
    auto controller = new IterPatchController(config);
    auto web = new IterPatchInterface(controller);

    auto router = new URLRouter;
    router.get("/static/*", serveStaticFiles("./static/", new HTTPFileServerSettings("/static/")));
    web.register(router);

    auto settings = new HTTPServerSettings;
    settings.sessionStore = new MemorySessionStore;
    settings.port = config.serverPort;

    listenHTTP(settings, router);


    //import std.stdio:writeln;
    //controller.addUser(new User("oleg", "oleg", "Олег Леленков"));
    //User user = controller.getUserByUserName("oleg");
    //writeln(user.password);

}
