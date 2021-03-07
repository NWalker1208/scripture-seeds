import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

import '../service.dart';

class FirebaseService extends CustomService<FirebaseApp> {
  @override
  Future<FirebaseApp> open() async {
    try {
      return await Firebase.initializeApp();
    } on MissingPluginException {
      print('Current platform does not support Firebase.');
      return null;
    }
  }

  Future<FirebaseAuth> get _firebaseAuth async =>
      FirebaseAuth.instanceFor(app: await data);

  /// Returns the current Firebase user. Null if not signed in.
  Future<User> get currentUser async => (await _firebaseAuth).currentUser;

  /// Returns true if signed into Firebase.
  Future<bool> get signedIn async => await currentUser != null;

  /// Returns a stream that sends updates when the user changes.
  Future<Stream<User>> get userChanges async =>
      (await _firebaseAuth).userChanges();

  /// Returns a Google Drive API for the current user.
  /// Null if not signed into Google.
  Future<drive.DriveApi> get driveApi async {
    final googleUser = await _googleSignIn.signInSilently();
    if (googleUser == null) return null;
    return drive.DriveApi(_GoogleAuthClient(googleUser));
  }

  /// Google Sign In configuration
  GoogleSignIn get _googleSignIn => GoogleSignIn(scopes: const [
        drive.DriveApi.driveAppdataScope,
      ]);

  /// Signs the user into Firebase using Google.
  Future<bool> signIn() async {
    if (await signedIn) return true;

    // Trigger google sign in screen
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      print('Unable to sign in with Google.');
      return false;
    }
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Authenticate with Firebase
    final app = await data;
    try {
      await FirebaseAuth.instanceFor(app: app).signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Unable to sign in: $e');
      return false;
    }
  }

  /// Signs the user out of Firebase.
  Future<void> signOut() async {
    if (!await signedIn) return;
    final app = await data;
    await FirebaseAuth.instanceFor(app: app).signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<void> close() async {
    final app = await data;
    await app.delete();
    await super.close();
  }
}

class _GoogleAuthClient extends http.BaseClient {
  _GoogleAuthClient(this.user) : super();

  final GoogleSignInAccount user;
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      _client.send(request..headers.addAll(await user.authHeaders));
}
