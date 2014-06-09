module itercontroller;

private {
    import std.string: toStringz;
    import std.conv: to;
    import std.datetime: Clock;
    import std.array: appender;
}

private {
    import vibe.core.log;
    import config;
    import sqlite3;
}

//class IterPatchController {
//    private {
//        IterPatchConfig config;
//        SqliteDatabase sqldb;
//    }

//    this(IterPatchConfig config) {
//        this.config = config;
//        sqldb = new SqliteDatabase(config.databaseName);
//    }

//    void addUser(User user) {
//        string query = "INSERT INTO USERS(USERNAME, PASSWORD, FIO) VALUES (?, ?, ?)";
//        try {
//            sqldb.execute(query, user.username, user.password, user.fio);
//        } catch (Sqlite3Exception e) {
//            logError("Not add user %s", user.username);
//        }
//    }

//    User getUserByUserName(string username) {
//        string query = "SELECT ID, USERNAME, PASSWORD, FIO FROM USERS WHERE USERNAME=?";
//        User result;
//        try {
//            Sqlite3Statement stmt = sqldb.query(query, username);
//            result = new User();
//            result._id = stmt.getValue!long(0);
//            result.username = stmt.getValue!string(1);
//            result.password = stmt.getValue!string(2);
//            result.fio = stmt.getValue!string(3);
//        } catch (Sqlite3Exception e) {
//            logError("Not found user %s", username);
//        }
//        return result;
//    }

//    Patch[] getAllPatches() {
//        string query = "SELECT p.ID, p.USER_ID, u.USERNAME, p.CREATE_DATE FROM PATCHES p LEFT JOIN USERS u ON p.USER_ID = u.ID ORDER BY p.ID DESC";
//        auto result = appender!(Patch[])();
//        Sqlite3Statement stmt = sqldb.query(query);
        
//        do {
//            Patch p = new Patch();
//            p._id = stmt.getValue!long(0);
//            p.user_id = stmt.getValue!long(1);
//            p.username = stmt.getValue!string(2);
//            p.create_date = stmt.getValue!string(3);
//            result.put(p);
//        } while(stmt.step());

//        return result.data;
//    }

//    void nextPatch(string username) {
//        string query = "INSERT INTO PATCHES(USER_ID, CREATE_DATE) VALUES (?, ?)";
//        User user = getUserByUserName(username);
//        if (user is null)
//            return;
//        try {
//            sqldb.execute(query, user._id, Clock.currTime().toSimpleString()[0..20]);
//        } catch (Sqlite3Exception e) {
//            logError("Not add patch");
//        }
//    }
//}

//class User {
//    long _id;
//    string username;
//    string password;
//    string fio;

//    this() {}

//    this(string username, string password, string fio) {
//        this.username = username;
//        this.password = password;
//        this.fio = fio;
//    }

//    override
//    string toString() {
//        return username ~ " | " ~ fio;
//    }
//}

//class Patch {
//    long _id;
//    long user_id;
//    string username;
//    string create_date;

//    override
//    string toString() {
//        return number.to!string ~ " | " ~ create_date;
//    }

//    @property 
//    long number() {
//        return _id;
//    }
//}
