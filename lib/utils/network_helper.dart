import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static Future<bool> isOffline() async {
    var result = await Connectivity().checkConnectivity();
    return result == ConnectivityResult.none;
  }
}
