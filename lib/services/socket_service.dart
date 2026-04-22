import 'dart:developer' as dev;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/api_constants.dart';

class SocketService {
  late io.Socket socket;

  SocketService() {
    _init();
  }

  void _init() {
    socket = io.io(
      ApiConstants.websocketUrl,
      io.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      dev.log('Socket connected: ${socket.id}');
    });

    socket.onDisconnect((_) {
      dev.log('Socket disconnected');
    });

    socket.onConnectError((err) {
      dev.log('Socket connect error: $err');
    });

    // Listen for events
    socket.on('new-signal', (data) {
      dev.log('Event new-signal received: $data');
    });

    socket.on('forex_signals_new', (data) {
      dev.log('Event forex_signals_new received: $data');
    });

    socket.on('analysis_new', (data) {
      dev.log('Event analysis_new received: $data');
    });

    socket.on('notifications_new', (data) {
      dev.log('Event notifications_new received: $data');
    });

    socket.on('broadcasts_new', (data) {
      dev.log('Event broadcasts_new received: $data');
    });

    socket.on('new_message', (data) {
      dev.log('Event new_message received: $data');
    });

    socket.on('user_typing', (data) {
      dev.log('Event user_typing received: $data');
    });
  }

  // Emit methods
  void identify(String userId) {
    socket.emit('identify', {'userId': userId});
    dev.log('Emitted identify for userId: $userId');
  }

  void joinTicket(String ticketId) {
    socket.emit('join_ticket', {'ticketId': ticketId});
    dev.log('Emitted join_ticket for ticketId: $ticketId');
  }

  void sendMessage(Map<String, dynamic> message) {
    socket.emit('send_message', message);
    dev.log('Emitted send_message: $message');
  }

  void dispose() {
    socket.dispose();
  }
}

final socketServiceProvider = Provider<SocketService>((ref) {
  final service = SocketService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});
