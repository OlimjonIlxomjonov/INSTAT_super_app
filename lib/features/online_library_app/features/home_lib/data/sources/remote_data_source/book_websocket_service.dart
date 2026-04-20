import 'dart:convert';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class BookWebSocketService {
  WebSocketChannel? _channel;

  Stream<dynamic>? get stream => _channel?.stream;

  void connect() {
    final token = TokenStorageServiceImpl().getAccessToken();
    if (token == null || token.isEmpty) return;

    try {
      final wsUrl = Uri.parse('wss://test.avacoder.uz/ws/books/?token=$token');
      _channel = WebSocketChannel.connect(wsUrl);
      logger.i("WebSocket connected to $wsUrl");
    } catch (e) {
      logger.e("WebSocket connection error: $e");
    }
  }

  void disconnect() {
    _channel?.sink.close(status.goingAway);
    _channel = null;
    logger.i("WebSocket disconnected");
  }
}
