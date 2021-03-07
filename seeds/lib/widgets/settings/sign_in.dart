import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase/provider.dart';

class GoogleSignInTile extends StatelessWidget {
  const GoogleSignInTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<FirebaseProvider>(
        builder: (context, firebase, child) {
          if (!firebase.isLoaded) return CircularProgressIndicator();
          final user = firebase.currentUser;
          return ListTile(
            onTap: () {
              if (firebase.signedIn) {
                firebase.signOut();
              } else {
                firebase.signIn();
              }
            },
            leading: firebase.signedIn
                ? CircleAvatar(backgroundImage: NetworkImage(user.photoURL))
                : null,
            title: Text(user?.displayName ?? 'Sign In'),
          );
        },
      );
}
