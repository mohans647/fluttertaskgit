import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ConnectionStatus extends ChangeNotifier {
  ConnectivityResult _status = ConnectivityResult.none;

  ConnectivityResult get status => _status;

  void updateConnectionStatus(ConnectivityResult newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}