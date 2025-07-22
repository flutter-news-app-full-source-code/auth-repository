//
// ignore_for_file: comment_references

import 'dart:async';

import 'package:auth_client/auth_client.dart';
import 'package:core/core.dart';
import 'package:ht_kv_storage_service/ht_kv_storage_service.dart';

/// {@template auth_repository}
/// A repository that manages authentication operations.
///
/// This repository acts as an abstraction layer over an [AuthClient],
/// providing a consistent interface for authentication flows and
/// propagating standardized exceptions.
/// {@endtemplate}
class AuthRepository {
  /// {@macro auth_repository}
  ///
  /// Requires an instance of [AuthClient] to handle the actual
  /// authentication operations.
  const AuthRepository({
    required AuthClient authClient,
    required HtKVStorageService storageService,
  }) : _authClient = authClient,
       _storageService = storageService;

  final AuthClient _authClient;
  final HtKVStorageService _storageService;

  /// Stream emitting the current authenticated [User] or `null`.
  ///
  /// Delegates to the underlying [AuthClient]'s stream.
  Stream<User?> get authStateChanges => _authClient.authStateChanges;

  /// Retrieves the currently authenticated [User], if any.
  ///
  /// Delegates to the underlying [AuthClient]'s method.
  ///
  /// Throws [HttpException] or its subtypes on failure, as propagated
  /// from the client.
  Future<User?> getCurrentUser() async {
    try {
      return await _authClient.getCurrentUser();
    } on HttpException {
      rethrow; // Propagate client-level exceptions
    }
    // Catch-all for unexpected errors is generally avoided here,
    // relying on the client's defined exceptions.
  }

  /// Initiates the sign-in/sign-up process using the email+code flow.
  ///
  /// This method is context-aware and can signal a dashboard login.
  /// Delegates to the underlying [AuthClient]'s method.
  ///
  /// Throws [HttpException] or its subtypes on failure, as propagated
  /// from the client.
  Future<void> requestSignInCode(
    String email, {
    bool isDashboardLogin = false,
  }) async {
    try {
      await _authClient.requestSignInCode(
        email,
        isDashboardLogin: isDashboardLogin,
      );
    } on HttpException {
      rethrow; // Propagate client-level exceptions
    }
  }

  /// Verifies the email code provided by the user and completes sign-in/sign-up.
  ///
  /// This method is context-aware and can signal a dashboard login.
  /// Delegates to the underlying [AuthClient]'s method.
  ///
  /// Throws [HttpException] or its subtypes on failure, as propagated
  /// from the client.
  Future<User> verifySignInCode(
    String email,
    String code, {
    bool isDashboardLogin = false,
  }) async {
    try {
      final authResponse = await _authClient.verifySignInCode(
        email,
        code,
        isDashboardLogin: isDashboardLogin,
      );
      // authResponse is AuthSuccessResponse
      final token = authResponse.token;
      final user = authResponse.user;
      await saveAuthToken(token);
      return user;
    } on HttpException {
      rethrow; // Propagate client-level exceptions
    } on StorageException {
      rethrow; // Propagate storage exceptions during token save
    }
  }

  /// Signs in the user anonymously.
  ///
  /// Delegates to the underlying [AuthClient]'s method.
  /// After successful sign-in, saves the token and returns the user.
  ///
  /// Throws [HttpException] or its subtypes on failure, as propagated
  /// from the client.
  /// Throws [StorageException] if saving the token fails.
  Future<User> signInAnonymously() async {
    try {
      final authResponse = await _authClient.signInAnonymously();
      // authResponse is AuthSuccessResponse
      final token = authResponse.token;
      final user = authResponse.user;
      await saveAuthToken(token);
      return user;
    } on HttpException {
      rethrow; // Propagate client-level exceptions
    } on StorageException {
      rethrow; // Propagate storage exceptions during token save
    }
  }

  /// Signs out the current user (whether authenticated normally or anonymously).
  ///
  /// Delegates to the underlying [AuthClient]'s method.
  /// After successful sign-out, clears the authentication token from storage.
  ///
  /// Throws [HttpException] or its subtypes on failure, as propagated
  /// from the client.
  /// Throws [StorageException] if clearing the token fails.
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
      await clearAuthToken();
    } on HttpException {
      rethrow; // Propagate client-level exceptions
    } on StorageException {
      rethrow; // Propagate storage exceptions during token clear
    }
  }

  /// Saves the authentication token to storage.
  ///
  /// Throws [StorageWriteException] if the write operation fails.
  Future<void> saveAuthToken(String token) async {
    try {
      await _storageService.writeString(
        key: StorageKey.authToken.stringValue,
        value: token,
      );
    } on StorageWriteException {
      rethrow;
    }
  }

  /// Retrieves the authentication token from storage.
  ///
  /// Returns `null` if the token is not found.
  /// Throws [StorageReadException] if the read operation fails for other reasons.
  /// Throws [StorageTypeMismatchException] if the stored value is not a string.
  Future<String?> getAuthToken() async {
    try {
      return await _storageService.readString(
        key: StorageKey.authToken.stringValue,
      );
    } on StorageReadException {
      rethrow;
    } on StorageTypeMismatchException {
      rethrow;
    }
  }

  /// Clears the authentication token from storage.
  ///
  /// Throws [StorageDeleteException] if the delete operation fails.
  Future<void> clearAuthToken() async {
    try {
      await _storageService.delete(key: StorageKey.authToken.stringValue);
    } on StorageDeleteException {
      rethrow;
    }
  }
}
