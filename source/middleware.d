module middleware;

private {
    import std.stdio: writeln;
}

private {
    import common;
    import vibe.http.server;
    import vibe.http.router;
    import vibe.http.common;
}

class MiddlewareContainer : HTTPServerRequestHandler {
    mixin Singleton!MiddlewareContainer;

    Middleware[] middlewares;
    URLRouter router;

    void handleRequest(HTTPServerRequest req, HTTPServerResponse res) {
        foreach (Middleware middl; middlewares) {
            if (middl.process_request(req, res)) {
                return;
            }
        }
        if (router) router.handleRequest(req, res);
        foreach (Middleware middl; middlewares) {
            if (middl.process_response(req, res)) {
                return;
            }
        }
    }

    void addMiddleware(Middleware middleware) {
        middlewares ~= middleware;
    }


    void setRouter(URLRouter router) {
        this.router = router;
    }
}


MiddlewareContainer createMiddlewareContainer(URLRouter router) {
    MiddlewareContainer container = MiddlewareContainer.getInstance();
    container.setRouter(router);
    return container;
}


interface Middleware {
    bool process_request(HTTPServerRequest req, HTTPServerResponse res);
    bool process_response(HTTPServerRequest req, HTTPServerResponse res);
}


class PermissionMiddleware : Middleware {
    HTTPServerRequestDelegate handler;

    this() {

    }

    this(HTTPServerRequestDelegate handler) {
        this.handler = handler;
    }

    bool process_request(HTTPServerRequest req, HTTPServerResponse res) {
        auto session = req.session;
        enforceHTTP(session || handler, HTTPStatus.forbidden, "Permission denied!");
        if (!session) {
            handler(req, res);
            return true;
        }
        return false;
    }

    bool process_response(HTTPServerRequest req, HTTPServerResponse res) {
        return false;
    }
}