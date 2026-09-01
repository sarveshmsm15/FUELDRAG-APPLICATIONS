import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/secure_storage.dart';
import '../../core/constants/env_config.dart';

enum SocketState { disconnected, connecting, connected, error }

class SocketService {
  IO.Socket? _socket;
  SocketState _state = SocketState.disconnected;
  SocketState get state => _state;

  final Map<String, List<void Function(dynamic)>> _listeners = {};

  Future<void> connect() async {
    if (_socket?.connected == true) return;
    _state = SocketState.connecting;

    final token = await SecureStorage.getAccessToken();
    if (token == null) { _state = SocketState.error; return; }

    _socket = IO.io(
      EnvConfig.apiBaseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) { _state = SocketState.connected; _notifyListeners('connect', null); });
    _socket!.onDisconnect((_) { _state = SocketState.disconnected; _notifyListeners('disconnect', null); });
    _socket!.onConnectError((data) { _state = SocketState.error; _notifyListeners('error', data); });
    _socket!.on('driver:locationUpdate', (data) => _notifyListeners('driver:locationUpdate', data));
    _socket!.on('order:statusUpdate', (data) => _notifyListeners('order:statusUpdate', data));
    _socket!.on('notification:new', (data) => _notifyListeners('notification:new', data));
    _socket!.on('chat:newMessage', (data) => _notifyListeners('chat:newMessage', data));
    _socket!.connect();
  }

  void disconnect() { _socket?.disconnect(); _socket?.dispose(); _socket = null; _state = SocketState.disconnected; }
  void trackOrder(String orderId) { _socket?.emit('track:order', orderId); }
  void untrackOrder(String orderId) { _socket?.emit('untrack:order', orderId); }
  void joinChat(String chatId) { _socket?.emit('chat:join', chatId); }
  void sendChatMessage(String chatId, String message) { _socket?.emit('chat:message', {'chatId': chatId, 'message': message}); }

  void on(String event, void Function(dynamic) callback) { _listeners.putIfAbsent(event, () => []); _listeners[event]!.add(callback); }
  void off(String event, void Function(dynamic) callback) { _listeners[event]?.remove(callback); }

  void _notifyListeners(String event, dynamic data) { for (final cb in _listeners[event] ?? []) { cb(data); } }
}

final socketServiceProvider = Provider<SocketService>((ref) { final s = SocketService(); ref.onDispose(() => s.disconnect()); return s; });

final socketStateProvider = NotifierProvider<SocketStateNotifier, SocketState>(SocketStateNotifier.new);

class SocketStateNotifier extends Notifier<SocketState> {
  @override
  SocketState build() => SocketState.disconnected;
  void set(SocketState s) => state = s;
}
