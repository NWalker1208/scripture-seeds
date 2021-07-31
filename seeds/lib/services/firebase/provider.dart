import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/drive/v3.dart' as google_drive;

import '../provider.dart';
import 'drive.dart';
import 'service.dart';

class FirebaseProvider extends ServiceProvider<FirebaseService> {
  FirebaseProvider() : super(() => FirebaseService());

  StreamSubscription _authSubscription;

  User _currentUser;
  google_drive.DriveApi _driveApi;

  User get currentUser => _currentUser;
  bool get signedIn => _currentUser != null;
  DriveStorage get drive => _driveApi == null ? null : DriveStorage(_driveApi);

  /// Attempts to sign into Firebase. Returns true if successful.
  Future<bool> signIn() => access((service) => service.signIn());

  /// Signs out of Firebase.
  Future<void> signOut() => access((service) => service.signOut());

  @override
  Future<void> loadData(FirebaseService service) async {
    _currentUser = await service.currentUser;
    _driveApi =  await service.driveApi;
    // Listen to authentication changes
    await _authSubscription?.cancel();
    _authSubscription = (await service.userChanges).listen((user) async {
      _currentUser = user;
      _driveApi = await service.driveApi;
      notifyListeners();
    });
  }

  @override
  void notifyListeners() {
    if (signedIn) {
      print('Firebase is signed in. User = ${_currentUser.email}');
    } else {
      print('Firebase is not signed in.');
    }
    super.notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
