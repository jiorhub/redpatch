#!/usr/bin/env rdmd

import std.stdio: writeln, File;
import std.file;
import std.path;
import std.array;
import std.algorithm: joiner, canFind;
import std.process;
import std.json;
import std.getopt;
import std.string: strip;

enum string[] EXTENSIONS = [".d", ".a"];
enum SOURCE_PATH = "./source/";
enum IS_SOURSE = 33188;
enum COMPILER = "dmd";

class Config {
    private {
        string[] _libs;
        string[] _pathLibs;
        string _nameApp;
        string[] _versions;
        bool _isUnittest;
        string[] _stringImports;
    }
    this(string fileName){
        auto json = parseJSON(readText(fileName));
        foreach(lib ; json["libs"].array) {
            _libs ~= lib.str;
        }
        foreach(lib ; json["pathLibs"].array) {
            _pathLibs ~= lib.str;
        }
        foreach(ver; json["versions"].array) {
            _versions ~= ver.str;
        }
        foreach(simp; json["stringImports"].array) {
            _stringImports ~= simp.str;
        }
        _nameApp = json["nameApp"].str;
        _isUnittest = json["unittest"].integer == 0 ? false : true;
    }

    string[] getLibs() {
        return _libs;
    }

    string[] getVesions() {
        return _versions;
    }

    string getNameApp() {
        return _nameApp;
    }

    bool isUnittests() {
        return _isUnittest;
    }

    string[] getStringImports() {
        return _stringImports;
    }

    string[] getPathLibs() {
      return _pathLibs;
    }
}

int init() {
    if (!SOURCE_PATH.exists())
        mkdir(SOURCE_PATH);
    
    string mainFilePath = buildPath(SOURCE_PATH, "main.d");
    if (!mainFilePath.exists()) {
        File mainFile = File(mainFilePath, "w");
        scope(exit) mainFile.close();    
        mainFile.writeln(q{module main;

            int main(string[] args) {
                return 0;
            }
        });
    }
    return 0;
}

int build(string configFileName) {
    auto config = new Config("build.json");

    auto command = appender!(string[])();
    command.put(COMPILER);

    if (!SOURCE_PATH.exists())
        init();

    foreach (string name; dirEntries(SOURCE_PATH, SpanMode.depth)) {
        if(isDir(name)) {
            continue;
        }
        if(!canFind(EXTENSIONS, extension(name))) {
            continue;
        }
        command.put(name);
    }

    command.put("-of" ~ config.getNameApp());

    foreach(pLibs; config.getPathLibs()) {
        if(pLibs.strip().length > 0)
            command.put("-L-L" ~ pLibs);
    }

    foreach(lib ; config.getLibs()) {
        if(lib.strip().length > 0)
            command.put("-L-l" ~ lib);
    }

    foreach(simp; config.getStringImports()) {
        if(simp.strip().length > 0)
            command.put("-J" ~ simp);
    }

    foreach(ver; config.getVesions()) {
        if(ver.strip().length > 0)
            command.put("-version=" ~ ver);
    }

    if(config.isUnittests)
        command.put("-unittest");

    writeln(command.data);
    auto pid = spawnProcess(command.data);
    if(wait(pid) != 0) {
        writeln("failed");
        return 1;
    } else {
        writeln("complete");
    }
    return 0;
}

int main(string[] args) {
    string fileConf;
    bool isBuild;
    bool isInit;

    getopt(args,
        std.getopt.config.passThrough,
        "file|f", &fileConf
    );

    if (fileConf is null || !fileConf.exists()) {
        fileConf = "build.json";    
    }

    if (args.length > 1) {
        if (args[1] == "init")
            return init();    
    }

    return build(fileConf);
}
