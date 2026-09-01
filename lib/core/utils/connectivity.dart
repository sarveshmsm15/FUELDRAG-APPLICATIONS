import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity state provider — monitors network status in real-time.
final connectivityProvider = StreamProvider<ConnectivityState>((ref) {
  final service = ConnectivityService();
  return service.stream;
});

/// Current connectivity state.
enum ConnectivityState {
  online,
  offline,
  limited,
}

/// Service that wraps connectivity_plus and exposes a stream.
class ConnectivityService {
  ConnectivityService() {
    _controller = StreamController<ConnectivityState>.broadcast();
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
    // Emit initial state
    _checkCurrent();
  }

  final _connectivity = Connectivity();
  late final StreamController<ConnectivityState> _controller;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  Stream<ConnectivityState> get stream => _controller.stream;

  ConnectivityState _currentState = ConnectivityState.online;
  ConnectivityState get currentState => _currentState;

  bool get isOnline => _currentState == ConnectivityState.online;

  Future<void> _checkCurrent() async {
    final results = await _connectivity.checkConnectivity();
    _onChanged(results);
  }

  void _onChanged(List<ConnectivityResult> results) {
    ConnectivityState newState;

    if (results.contains(ConnectivityResult.none)) {
      newState = ConnectivityState.offline;
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      newState = ConnectivityState.limited;
    } else {
      newState = ConnectivityState.online;
    }

    if (newState != _currentState) {
      _currentState = newState;
      _controller.add(newState);
    }
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}