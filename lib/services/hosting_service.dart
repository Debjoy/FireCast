import 'dart:io';

import 'package:get_ip/get_ip.dart';

import 'package:http_server/http_server.dart';

class HostingService {
  String ipAddress = "";
  HttpServer serverHttp;

  Future<String> startHosting(String mediaDirectory) async {
    ipAddress = await GetIp.ipAddress;
    if (serverHttp != null) {
      serverHttp.close(force: true);
      serverHttp = null;
    }
    if (mediaDirectory == "") mediaDirectory = "/storage/emulated/0";
    var staticFiles = new VirtualDirectory(mediaDirectory)
      ..allowDirectoryListing = true;
    serverHttp = await HttpServer.bind(ipAddress, 8082).then((server) {
      server.listen(staticFiles.serveRequest);
      return server;
    });

    return "http://$ipAddress:8082";
  }

  Future<void> stopHosting() async {
    await serverHttp.close(force: true);
    serverHttp = null;
  }
}
