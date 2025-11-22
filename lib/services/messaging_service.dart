import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingServiceProvider = Provider<MessagingService>((ref) => MessagingService(FirebaseMessaging.instance));
final messagingInitializationProvider = FutureProvider<void>((ref) async {
  await ref.watch(messagingServiceProvider).initialize();
});

class MessagingService {
  MessagingService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<void> initialize() async {
    await _messaging.requestPermission();
    await _messaging.setAutoInitEnabled(true);
  }
}
