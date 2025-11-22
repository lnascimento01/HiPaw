import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Configurações do Firebase geradas para o projeto protocol-fisio-supreme.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions não suporta configuração web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não está configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByBQEPLXnBZeMG3fuIf0sVJoH5uMwEdQk',
    appId: '1:634907406412:android:8805ee6be51154a91404e9',
    messagingSenderId: '634907406412',
    projectId: 'protocol-fisio-supreme',
    storageBucket: 'protocol-fisio-supreme.firebasestorage.app',
  );

}