module config;

private {
	import common;
}

class Config {
	mixin Singleton!Config;

    enum serverPort = 8080;
    enum databaseName = "iterpatch.db";
}
