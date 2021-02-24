import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

/// Debug-only test page for testing new features.
class TestPage extends StatefulWidget {
  const TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<DateTime> items = [];

  void addItem() {
    setState(() {
      items.add(DateTime.now());
    });
  }

  void removeItem(DateTime item) {
    setState(() {
      items.remove(item);
    });
  }

  @override
  void initState() {
    addItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Test Page')),
        body: ListView(
          children: [
            ListTile(
              onTap: signInWithGoogle,
              title: Consumer<FirebaseApp>(
                builder: (context, app, child) {
                  if (app == null) return CircularProgressIndicator();
                  return Text(FirebaseAuth.instance.currentUser.displayName);
                },
              ),
            )
          ],
        ),
      );
}

// Test Functions

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) return null;

  // Obtain the auth details from the request
  final googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
