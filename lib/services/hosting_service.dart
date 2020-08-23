import 'package:get_ip/get_ip.dart';
import 'package:stream/stream.dart';

class HostingService {
  String ipAddress = "";
  HttpChannel channel;

  Future<String> startHosting(String mediaDirectory) async {
    ipAddress = await GetIp.ipAddress;
    if (channel != null) {
      channel.close();
      channel = null;
    }
    if (mediaDirectory == "") mediaDirectory = "/storage/emulated/0";

    StreamServer server = StreamServer(homeDir: mediaDirectory);
    channel = await server.start(port: 8082, address: ipAddress);

    return "http://$ipAddress:8082";
  }

  Future<void> stopHosting() async {
    await channel.close();
    channel = null;
  }
}
