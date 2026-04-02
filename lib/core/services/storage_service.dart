import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firebase Storage service provider.
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(FirebaseStorage.instance);
});

/// Firebase Storage service for image upload/download.
class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  /// Upload a file and return the download URL.
  Future<String> uploadFile({
    required String path,
    required File file,
    String? contentType,
  }) async {
    final ref = _storage.ref().child(path);
    final metadata = contentType != null
        ? SettableMetadata(contentType: contentType)
        : null;
    await ref.putFile(file, metadata);
    return await ref.getDownloadURL();
  }

  /// Upload bytes (for web) and return the download URL.
  Future<String> uploadBytes({
    required String path,
    required Uint8List bytes,
    String? contentType,
  }) async {
    final ref = _storage.ref().child(path);
    final metadata = contentType != null
        ? SettableMetadata(contentType: contentType)
        : null;
    await ref.putData(bytes, metadata);
    return await ref.getDownloadURL();
  }

  /// Get download URL for a path.
  Future<String> getDownloadUrl(String path) async {
    return await _storage.ref().child(path).getDownloadURL();
  }

  /// Delete a file.
  Future<void> deleteFile(String path) async {
    await _storage.ref().child(path).delete();
  }

  /// Generate a unique file path.
  static String generatePath({
    required String folder,
    required String userId,
    required String extension,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$folder/$userId/${timestamp}_$userId.$extension';
  }
}
