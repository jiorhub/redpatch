module iterinterface;

private {
    import vibe.d;
    import itercontroller;
}

class IterPatchInterface {
    private {
        IterPatchController controller;
    }

    this(IterPatchController controller) {
        this.controller = controller;
    }

    void register(URLRouter router) {
        router.get("/login", &showLogin);
        router.post("/login", &login);
        router.post("/next", &next); 
        router.get("/", &index);
    }

    void index(HTTPServerRequest req, HTTPServerResponse res) {
        auto session = req.session;
        if (!session) {
            res.redirect("/login");
            return;
        }

        Patch[] patches = controller.getAllPatches();

        res.renderCompat!("index.dt",
            HTTPServerRequest, "req",
            Patch[], "patches"
        )(req, patches);
    }

    void showLogin(HTTPServerRequest req, HTTPServerResponse res) {
        auto session = req.session;
        if (session) {
            res.redirect("/");
            return;
        }
        res.renderCompat!("login.dt",
            HTTPServerRequest, "req",
        )(req);
    }

    void login(HTTPServerRequest req, HTTPServerResponse res) {
        auto username = req.form["username"];
        auto password = req.form["password"];

        User user = controller.getUserByUserName(username);
        if (!user.username) {
            user = new User(username, password, "");
            controller.addUser(user);
        }

        if (user.password != password) {
            res.redirect("/login");
            return;    
        }

        auto session = req.session;
        if (!session) session = res.startSession();
        session["username"] = user.username;
        
        res.redirect("/");
    }



    void next(HTTPServerRequest req, HTTPServerResponse res) {
        auto session = req.session;
        if (!session) {
            res.redirect("/login");
            return;
        }
        controller.nextPatch(session["username"]);
        res.redirect("/");    
    }
}