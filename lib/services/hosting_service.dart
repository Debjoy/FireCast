import 'package:dhttpd/dhttpd.dart' as server;
import 'package:get_ip/get_ip.dart';

class HostingService {
  String ipAddress = "";
  server.Dhttpd serverHttp;

  Future<String> startHosting(String mediaDirectory) async {
    ipAddress = await GetIp.ipAddress;
    if (serverHttp != null) {
      serverHttp.destroy();
      serverHttp = null;
    }
    if (mediaDirectory == "") mediaDirectory = "/storage/emulated/0";
    serverHttp = await server.Dhttpd.start(
        port: 8082, address: ipAddress, path: mediaDirectory);

    return "http://$ipAddress:8082";
  }

  Future<void> stopHosting() async {
    await serverHttp.destroy();
    serverHttp = null;
  }
}
