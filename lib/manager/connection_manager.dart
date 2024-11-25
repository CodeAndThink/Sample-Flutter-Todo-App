import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionManager {
  static final shared = ConnectionManager();

  Future<int> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.last == ConnectivityResult.mobile) {
      return 0;
    } else if (connectivityResult.last == ConnectivityResult.wifi) {
      return 1;
    } else {
      return -1;
    }
  }
}
